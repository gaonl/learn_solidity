var web3;
var faucetContractAbi = [{"payable":true,"stateMutability":"payable","type":"fallback"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
var faucetContractByteCode = "0x608060405234801561001057600080fd5b5060ae8061001f6000396000f3fe608060405260043610601c5760003560e01c80632e1a7d4d14601e575b005b348015602957600080fd5b50601c60048036036020811015603e57600080fd5b50356040513390670de0b6b3a7640000830280156108fc02916000818181858888f193505050501580156075573d6000803e3d6000fd5b505056fea265627a7a72315820257c5a5cebe9c1a7a41d908c014c25d7d8bc0495fbcd915ceef3323d3a2e93dc64736f6c634300050c0032";

var FaucetContract;
var FaucetContractInstance;
function createFaucetContract(){
	// creation of contract object
	FaucetContract = web3.eth.contract(faucetContractAbi);
	
	var accountFrom = $("#currentAccount").text();
	
	FaucetContractInstance = FaucetContract.new({from:accountFrom,data:faucetContractByteCode}, function(err, myContract){
		if(!err) {
			if(myContract.address) {
				$("#contractAddress").text(myContract.address);
			}
		}
	});
	
}


function getOneFromFaucet(){
	var accountFrom = $("#currentAccount").text();
	FaucetContractInstance.withdraw(1,{from: accountFrom},function(err,result){
		console.log(result);
	});
	
}


function contribute(amount){
	var accountFrom = $("#currentAccount").text();
	var contractAddress = $("#contractAddress").text();
	web3.eth.sendTransaction({from: accountFrom, to: contractAddress, value: web3.toWei(amount)},function(err,result){
		alert(result);
	});
}



function initMetaMask(){
	
	if (ethereum) {
		web3 = new Web3(ethereum);
		try {
			ethereum.enable();
		} catch (error) {
			console.log(error);
		}
	} else if (web3) {
		web3 = new Web3(web3.currentProvider);
	}
}


$(document).ready(function(){
	initMetaMask();
	
	$("#createFaucetContract").click(function(){
		createFaucetContract();
	});
	
	$("#getOneFromFaucet").click(function(){
		getOneFromFaucet();
	});
	
	$("#contribute").click(function(){
		var amount = parseInt($("#contributeAmount").val());
		contribute(amount);
	});
	
	setInterval(function(){
		web3.eth.getAccounts(function(err,result){
			if (!err) {
				$("#currentAccount").text(result[0]);
			}
		});
	},1000);

});