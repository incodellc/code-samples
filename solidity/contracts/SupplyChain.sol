pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";
import "./AccessLib.sol";

// DO NOT USE THE CODE BELOW IN PRODUCTION
// This code is written strictly in demo purposes and does not represent any working solution,
// as well as does not contain any completed business logic
contract SupplyChain is Ownable {
  using AccessLib for AccessLib.Role;

  enum Status {
    Manufactured,
    Shipped,
    Received
  }

  struct Batch {
    bytes32 serialNumber;
    address currentOwner;
    uint256 timestamp;
    Status status;
  }

  mapping (string => AccessLib.Role) public roles;
  mapping (address => Batch) public batches;
  mapping (bytes32 => address) private newOwners;
  mapping (bytes32 => mapping (address => bool)) private isTransferred;

  event ManufacturerRegistered(address manufacturer, bool register);
  event BatchCreated(bytes32 batchId, address manufacturer, uint256 timestamp, uint status);
  event BatchShipped(bytes32 batchId, address from, address to);
  event BatchReceived(bytes32 batchId, address receiver, address shipper);

  //using string for code demo
  function registerRole(address _assignee, string _role) public ownerOnly {
    require(assignee != address(0));
    _registerRole(_assignee, keccak256(_role));
  }

  function createBatch(bytes32 _batchId, bytes32 serialNumber, uint status) public {
    roles[keccak256("manufacturer")].hasRole(msg.sender); //roles are hardcoded for demo
    require(!hasBatch(_batchId));
    batches[_batchId] = Batch(serialNumber, msg.sender, block.timestamp, Status.Manufactured);
    emit BatchCreated(_batchId, msg.sender, block.timestamp, status);
  }

  function shipBatch(bytes32 _batchId, address _newOwner) public {
    roles[keccak256("logistics")].hasRole(msg.sender);
    require(hasBatch(_batchId) && batches[_batchId].status == Status.Manufactured);
    newOwners[_batchId] = _newOwner;
    batches[_batchId].currentOwner = msg.sender;
    batches[_batchId].status = Status.Shipped;
    emit BatchShipped(_batchId, msg.sender, _newOwner);
  }

  function receiveBatch(bytes32 _batchId, address _from) public {
    roles[keccak256("sales authority")].hasRole(msg.sender);
    require(newOwners[_batchId] == msg.sender && hasBatch(_batchId) && batches[_batchId].status == Status.Shipped);
    isTransferred[_batchId][newOwners[_batchId]] = true;
    newProofOwners[_batchId] = 0x0;
    batches[_batchId].currentOwner = msg.sender;
    emit BatchReceived(_batchId, msg.sender, _from);
  }

  function hasRole(address _assignee, string _role) public view returns (bool) {
    return roles[keccak256(_role)].hasRole(_assignee);
  }

  function _registerRole(address _assignee, bytes32 _role) internal ownerOnly {
    roles[_role].addRole(_assignee);
  }

  function hasBatch(bytes32 batchId) view internal returns (bool exists) {
    return batches[batchId].currentOwner != address(0);
  }
}
