//"SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

contract Manager{
    address private managerAddress;
    function isOwner()pure  virtual  public returns(bool){
        return false;
    }
    function getManagerAddress() view public returns (address){
        return managerAddress;
    }
    constructor(address _managerAddress){
        managerAddress = _managerAddress;
    }
}

contract Owner is Manager{
    function isOwner()pure public override  returns(bool){
        return true;
    }
    constructor(address _ownerAddress) Manager(_ownerAddress){}
}

contract ManagersRepo{
    Manager[] managers = new Manager[](0);
    function isOwner(address _ownerAddress)view public returns(bool){
        if(getOwner()==_ownerAddress){
            return true;
        }
        return false;
    }

    function getOwner()public view returns(address){
        for(uint256 i = 0; i < managers.length; i++){
            if(managers[i].isOwner()){
                return managers[i].getManagerAddress();
            }
        }
        return address(0);
    }

    function isManager(address _managerAddress) view public returns(bool){
        for(uint256 i = 0; i < managers.length; i++){
            if(managers[i].getManagerAddress()==_managerAddress){
                return true;
            }
        }
        return false;
    }

    function getManagers()view public returns(address[] memory){
        address[] memory addresses = new address[](managers.length);
        for(uint256 i = 0; i < managers.length;i++){
            addresses[i] = managers[i].getManagerAddress();
        }
        return addresses;
    }

    function addManager(address _manager)public{
        require(isManager(msg.sender),"you are not manager. addManager function is allowed for manager.");
        require(!isManager(_manager),"He is already manager.");
        Manager manager = new Manager(_manager);
        managers.push(manager);
    }

    function deleteManager(address _manager)public{
        require(isManager(msg.sender),"You are not manager. deleteManager function is allowed for manager.");
        require(!isOwner(_manager),"Owner can not be deleted. use changeOwner function to delete original owner and generate new one.");
        uint256 i = 0;
        for(; i < managers.length; i++){
            if(managers[i].getManagerAddress()==_manager){
                managers[i] = managers[managers.length-1];
                managers.pop();
                return;
            }
        }
        require(false,"not found him in manager list");
    }
    function changeOwner(address _owner)public{
        require(!isManager(_owner),"He is already manager. Before use this function, you must delete him from managers list.(use deleteManager function!)");
        require(isOwner(msg.sender),"You are not owner. changeOwner function is allowed for owner.");
        Owner owner = new Owner(_owner);
        for(uint256 i = 0; i < managers.length; ++i){
            if(managers[i].isOwner()){
                managers[i] = owner;
                return ;
            }
        }
    }
    constructor(){
        Owner owner = new Owner(msg.sender);
        managers.push(owner);
    }
}
