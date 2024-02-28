pragma solidity ^0.8.0;

import "./node_validation.sol";

import "./BankAPIIntegration.sol";
import "./FiatTransactionMonitoring.sol";
contract KycProcess is NodeValidation {

    struct Business {
        string name;
        string country;
        bool isRegistered;
    }

    mapping(address => Business) public businesses;

    modifier onlyRegistered() {
        require(businesses[msg.sender].isRegistered, "Only registered businesses can operate nodes");
        _;
    }

    function getBankAccountInfo(address _businessAddress) public view onlyRegistered returns (BankAPIIntegration.AccountInfo memory) {
        BankAPIIntegration bankAPI = BankAPIIntegration(bankAPIAddress);
        BankAPIIntegration.AccountInfo memory accountInfo = bankAPI.getAccountInfo(_businessAddress);
        return accountInfo;
    }

    function transferTokens(address _from, address _to, uint256 _amount) public onlyRegistered {
        BankAPIIntegration bankAPI = BankAPIIntegration(bankAPIAddress);
        bankAPI.transferFiat(_from, _to, _amount);
        GainezisToken token = GainezisToken(tokenAddress);
        token.transfer(_from, _to, _amount);
    }
    function getTransactionHistory(address _businessAddress) public view onlyRegistered returns (BankAPIIntegration.Transaction[] memory) {

    function triggerFiatMonitoring(address _businessAddress) public onlyRegistered {
        BankAPIIntegration bankAPI = BankAPIIntegration(bankAPIAddress);
        FiatTransactionMonitoring ftm = FiatTransactionMonitoring(ftmAddress);
        FiatTransactionMonitoring ftm = FiatTransactionMonitoring(bankAPIAddress);
        ftm.monitorFiatTransaction(_businessAddress);
    }
        BankAPIIntegration bankAPI = BankAPIIntegration(bankAPIAddress);
        BankAPIIntegration.Transaction[] memory transactions = bankAPI.getTransactionHistory(_businessAddress);
        return transactions;
    }

    function setBankAPIAddress(address _bankAPIAddress) public onlyAdministrator {
    function setFtmAddress(address _ftmAddress) public onlyAdministrator {
        ftmAddress = _ftmAddress;
    }
        bankAPIAddress = _bankAPIAddress;
    }

    address public bankAPIAddress;
    address public ftmAddress;
    address public tokenAddress;
    function registerBusiness(address _businessAddress, string memory _name, string memory _country) public onlyAdministrator {
        businesses[_businessAddress] = Business(_name, _country, true);
    }

    function unregisterBusiness(address _businessAddress) public onlyAdministrator {
        businesses[_businessAddress].isRegistered = false;
    }

}
    function setTokenAddress(address _tokenAddress) public onlyAdministrator {
        tokenAddress = _tokenAddress;
    }




