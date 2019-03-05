pragma solidity >=0.4.21 <0.6.0;

library AccessLib {

	struct Role {
		mapping (address => bool) assignee;
	}

	function addRole(Role storage self, address _assignee) internal {
		require(_assignee != address(0));
		self.assignee[_assignee] = true;
	}

	function hasRole(Role storage self, address _assignee) internal view returns (bool) {
		require(_assignee != address(0));
		return self.assignee[_assignee];
	}

	function removeRole(Role storage self, address _assignee) internal {
		require(_assignee != address(0));
		self.assignee[_assignee] = false;
	}
}
