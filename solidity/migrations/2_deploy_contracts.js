var AccessLib = artifacts.require("./AccessLib.sol");
var SupplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
    deployer.deploy(AccessLib);
    deployer.link(AccessLib, SupplyChain);
    deployer.deploy(SupplyChain);
};