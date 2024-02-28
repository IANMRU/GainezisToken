pragma solidity ^0.8.0;
import "./bank_api_integration.sol";
import "./smart_contracts/GainezisToken/GainezisToken/FiatTransactionMonitoring.sol";


import "./kyc_process.sol";
contract NodeValidation {
    address private reserveBank;
    BankAPIIntegration private bankAPIIntegration;
    FiatTransactionMonitoring private fiatTransactionMonitoring;
    mapping (address => bool) private registeredBusinessNodes;

event InchainTransferSuccessful(address indexed _from, address indexed _to, uint256 _value, uint256 _fiatAmount);
    modifier onlyReserveBank() {
        require(msg.sender == reserveBank, "Only the Reserve Bank can call this function.");
        _;
    }

    constructor(address _reserveBank) {
        reserveBank = _reserveBank;
    }
        bankAPIIntegration = new BankAPIIntegration(_reserveBank);
        bankAPIIntegration = new BankAPIIntegration(_reserveBank);
        fiatTransactionMonitoring = new FiatTransactionMonitoring(_reserveBank);


    function inchainTransfer(address _from, address _to, uint256 _value) public {
        require(registeredBusinessNodes[_from], "Sender is not a registered business node.");
        require(registeredBusinessNodes[_to], "Receiver is not a registered business node.");
        uint256 fiatAmount = fiatTransactionMonitoring.calculateFiatAmount(_value);
bankAPIIntegration.transferFunds(_from, _to, fiatAmount);
GainezisToken token = GainezisToken(reserveBank);
token.transferFrom(_from, _to, _value);
emit InchainTransferSuccessful(_from, _to, _value, fiatAmount);
        fiatTransactionMonitoring.updateFiatTransactions(_from, _to, fiatAmount);
    }
function enhancedValidationCriteria(address _businessNode) internal view returns (bool);
    function addRegisteredBusinessNode(address _businessNode) public onlyReserveBank {
        bankAPIIntegration.connectBankAPI(_businessNode);
require(enhancedValidationCriteria(_businessNode), "Business node doesn't meet the enhanced validation criteria.");
registeredBusinessNodes[_businessNode] = true;
    }

    function removeRegisteredBusinessNode(address _businessNode) public onlyReserveBank {
        bankAPIIntegration.disconnectBankAPI(_businessNode);
        registeredBusinessNodes[_businessNode] = false;
    }

    function isRegisteredBusinessNode(address _businessNode) public view returns (bool) {
        return registeredBusinessNodes[_businessNode];
    }





