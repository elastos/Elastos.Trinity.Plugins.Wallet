var exec = require('cordova/exec');

var walletFunc = function() {};

function _exec(success, error, obj, fun, args) {
    function _onSuccess(ret) {
        if (success) {
            if (typeof(ret) == "string") {
                ret = JSON.parse(ret);
            }
            success(ret);
        }
    };
    exec(_onSuccess, error, obj, fun, args)
}

walletFunc.prototype.print = function(args, success, error) {
    exec(success, error, "Wallet", "print", args);
};


walletFunc.prototype.recoverWallet = function(args, success, error) {
    exec(success, error, "Wallet", "recoverWallet", args);
};

walletFunc.prototype.createWallet = function(args, success, error) {
    exec(success, error, "Wallet", "createWallet", args);
};

walletFunc.prototype.start = function(args, success, error) {
    exec(success, error, "Wallet", "start", args);
};

walletFunc.prototype.stop = function(args, success, error) {
    exec(success, error, "Wallet", "stop", args);
};

walletFunc.prototype.createSubWallet = function(args, success, error) {
    exec(success, error, "Wallet", "createSubWallet", args);
};

walletFunc.prototype.recoverSubWallet = function(args, success, error) {
    exec(success, error, "Wallet", "createSubWallet", args);
};


walletFunc.prototype.createMasterWallet = function(args, success, error) {
    exec(success, error, "Wallet", "createMasterWallet", args);
};

walletFunc.prototype.importWalletWithKeystore = function(args, success, error) {
    exec(success, error, "Wallet", "importWalletWithKeystore", args);
};

walletFunc.prototype.importWalletWithMnemonic = function(args, success, error) {
    exec(success, error, "Wallet", "importWalletWithMnemonic", args);
};

walletFunc.prototype.exportWalletWithKeystore = function(args, success, error) {
    exec(success, error, "Wallet", "exportWalletWithKeystore", args);
};
walletFunc.prototype.exportWalletWithMnemonic = function(args, success, error) {
    exec(success, error, "Wallet", "exportWalletWithMnemonic", args);
};

walletFunc.prototype.getBalanceInfo = function(args, success, error) {
    exec(success, error, "Wallet", "getBalanceInfo", args);
};

walletFunc.prototype.getBalance = function(args, success, error) {
    exec(success, error, "Wallet", "getBalance", args);
};

walletFunc.prototype.createAddress = function(args, success, error) {
    exec(success, error, "Wallet", "createAddress", args);
};

walletFunc.prototype.getAllAddress = function(args, success, error) {
    _exec(success, error, "Wallet", "getAllAddress", args);
};
walletFunc.prototype.getBalanceWithAddress = function(args, success, error) {
    exec(success, error, "Wallet", "getBalanceWithAddress", args);
};

walletFunc.prototype.generateMultiSignTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "generateMultiSignTransaction", args);
};
walletFunc.prototype.createMultiSignAddress = function(args, success, error) {
    exec(success, error, "Wallet", "createMultiSignAddress", args);
};
walletFunc.prototype.getAllTransaction = function(args, success, error) {
    _exec(success, error, "Wallet", "getAllTransaction", args);
};
walletFunc.prototype.sign = function(args, success, error) {
    exec(success, error, "Wallet", "sign", args);
};
walletFunc.prototype.checkSign = function(args, success, error) {
    exec(success, error, "Wallet", "checkSign", args);
};

walletFunc.prototype.deriveIdAndKeyForPurpose = function(args, success, error) {
    exec(success, error, "Wallet", "deriveIdAndKeyForPurpose", args);
};

walletFunc.prototype.getAllMasterWallets = function(args, success, error) {
    _exec(success, error, "Wallet", "getAllMasterWallets", args);
};

walletFunc.prototype.getBalanceInfo = function(args, success, error) {
    exec(success, error, "Wallet", "getBalanceInfo", args);

};


walletFunc.prototype.registerWalletListener = function(args, success, error) {
    exec(success, error, "Wallet", "registerWalletListener", args);

};


walletFunc.prototype.isAddressValid = function(args, success, error) {
    exec(success, error, "Wallet", "isAddressValid", args);
};

walletFunc.prototype.generateMnemonic = function(args, success, error) {
    exec(success, error, "Wallet", "generateMnemonic", args);
};

walletFunc.prototype.getWalletId = function(args, success, error) {
    exec(success, error, "Wallet", "getWalletId", args);
};

walletFunc.prototype.getAllChainIds = function(args, success, error) {
    exec(success, error, "Wallet", "getAllChainIds", args);
};

walletFunc.prototype.getSupportedChains = function(args, success, error) {
    exec(success, error, "Wallet", "getSupportedChains", args);
};

walletFunc.prototype.getAllSubWallets = function(args, success, error) {
    _exec(success, error, "Wallet", "getAllSubWallets", args);
};

walletFunc.prototype.changePassword = function(args, success, error) {
    exec(success, error, "Wallet", "changePassword", args);
};

walletFunc.prototype.sendRawTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "sendRawTransaction", args);
};

walletFunc.prototype.createTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createTransaction", args);
};


walletFunc.prototype.createDID = function(args, success, error) {
    exec(success, error, "Wallet", "createDID", args);
};

walletFunc.prototype.getDIDList = function(args, success, error) {
    exec(success, error, "Wallet", "getDIDList", args);
};

walletFunc.prototype.destoryDID = function(args, success, error) {
    exec(success, error, "Wallet", "destoryDID", args);
};

walletFunc.prototype.didSetValue = function(args, success, error) {
    exec(success, error, "Wallet", "didSetValue", args);
};

walletFunc.prototype.didGetValue = function(args, success, error) {
    exec(success, error, "Wallet", "didGetValue", args);
};

walletFunc.prototype.didGetHistoryValue = function(args, success, error) {
    exec(success, error, "Wallet", "didGetHistoryValue", args);
};


walletFunc.prototype.didGetAllKeys = function(args, success, error) {
    exec(success, error, "Wallet", "didGetAllKeys", args);
};


walletFunc.prototype.didSign = function(args, success, error) {
    exec(success, error, "Wallet", "didSign", args);
};

walletFunc.prototype.didCheckSign = function(args, success, error) {
    exec(success, error, "Wallet", "didCheckSign", args);
};

walletFunc.prototype.didGetPublicKey = function(args, success, error) {
    exec(success, error, "Wallet", "didGetPublicKey", args);
};

walletFunc.prototype.destroyWallet = function(args, success, error) {
    exec(success, error, "Wallet", "destroyWallet", args);
};

walletFunc.prototype.createIdTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createIdTransaction", args);
};

walletFunc.prototype.createDepositTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createDepositTransaction", args);
};

walletFunc.prototype.createWithdrawTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createWithdrawTransaction", args);
};

walletFunc.prototype.getGenesisAddress = function(args, success, error) {
    exec(success, error, "Wallet", "getGenesisAddress", args);
};


walletFunc.prototype.didGenerateProgram = function(args, success, error) {
    exec(success, error, "Wallet", "didGenerateProgram", args);
};

walletFunc.prototype.getAllCreatedSubWallets = function(args, success, error) {
    exec(success, error, "Wallet", "getAllCreatedSubWallets", args);
};

walletFunc.prototype.createMultiSignMasterWalletWithPrivKey = function(args, success, error) {
    exec(success, error, "Wallet", "createMultiSignMasterWalletWithPrivKey", args);

};

walletFunc.prototype.createMultiSignMasterWallet = function(args, success, error) {
    exec(success, error, "Wallet", "createMultiSignMasterWallet", args);

};


walletFunc.prototype.getMasterWalletBasicInfo = function(args, success, error) {
    _exec(success, error, "Wallet", "getMasterWalletBasicInfo", args);
};

walletFunc.prototype.signTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "signTransaction", args);
};

walletFunc.prototype.publishTransaction = function(args, success, error) {
    _exec(success, error, "Wallet", "publishTransaction", args);
};

walletFunc.prototype.getMasterWalletPublicKey = function(args, success, error) {
    exec(success, error, "Wallet", "getMasterWalletPublicKey", args);
};

walletFunc.prototype.getSubWalletPublicKey = function(args, success, error) {
    exec(success, error, "Wallet", "getSubWalletPublicKey", args);
};

walletFunc.prototype.createMultiSignMasterWalletWithMnemonic = function(args, success, error) {
    exec(success, error, "Wallet", "createMultiSignMasterWalletWithMnemonic", args);
};

walletFunc.prototype.removeWalletListener = function(args, success, error) {
    exec(success, error, "Wallet", "removeWalletListener", args);
};

walletFunc.prototype.disposeNative = function(args, success, error) {
    exec(success, error, "Wallet", "disposeNative", args);
};

walletFunc.prototype.getMultiSignPubKeyWithMnemonic = function(args, success, error) {
    exec(success, error, "Wallet", "getMultiSignPubKeyWithMnemonic", args);
};

walletFunc.prototype.getMultiSignPubKeyWithPrivKey = function(args, success, error) {
    exec(success, error, "Wallet", "getMultiSignPubKeyWithPrivKey", args);
};

walletFunc.prototype.getTransactionSignedSigners = function(args, success, error) {
    _exec(success, error, "Wallet", "getTransactionSignedSigners", args);
};

walletFunc.prototype.importWalletWithOldKeystore = function(args, success, error) {
    exec(success, error, "Wallet", "importWalletWithOldKeystore", args);
};

walletFunc.prototype.getVersion = function(args, success, error) {
    exec(success, error, "Wallet", "getVersion", args);
};

walletFunc.prototype.destroySubWallet = function(args, success, error) {
    exec(success, error, "Wallet", "destroySubWallet", args);
};

walletFunc.prototype.getVotedProducerList = function(args, success, error) {
    exec(success, error, "Wallet", "getVotedProducerList", args);
};

walletFunc.prototype.createVoteProducerTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createVoteProducerTransaction", args);
};

walletFunc.prototype.createCancelProducerTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createCancelProducerTransaction", args);
};

walletFunc.prototype.getRegisteredProducerInfo = function(args, success, error) {
    exec(success, error, "Wallet", "getRegisteredProducerInfo", args);
};

walletFunc.prototype.createRegisterProducerTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createRegisterProducerTransaction", args);
};


walletFunc.prototype.generateProducerPayload = function(args, success, error) {
    exec(success, error, "Wallet", "generateProducerPayload", args);
};

walletFunc.prototype.generateCancelProducerPayload = function(args, success, error) {
    exec(success, error, "Wallet", "generateCancelProducerPayload", args);
};

walletFunc.prototype.getPublicKeyForVote = function(args, success, error) {
    exec(success, error, "Wallet", "getPublicKeyForVote", args);
};

walletFunc.prototype.createRetrieveDepositTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createRetrieveDepositTransaction", args);
};


walletFunc.prototype.createUpdateProducerTransaction = function(args, success, error) {
    exec(success, error, "Wallet", "createUpdateProducerTransaction", args);
};

var WALLETFUNC = new walletFunc();
module.exports = WALLETFUNC;