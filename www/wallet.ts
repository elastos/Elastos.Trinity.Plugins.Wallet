/*
* Copyright (c) 2018-2020 Elastos Foundation
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

let exec = cordova.exec;

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

class WalletManagerImpl implements WalletPlugin.WalletManager {
    print(args, success, error) {
        exec(success, error, "Wallet", "print", args);
    };

    recoverWallet(args, success, error) {
        exec(success, error, "Wallet", "recoverWallet", args);
    };

    createWallet(args, success, error) {
        exec(success, error, "Wallet", "createWallet", args);
    };

    start(args, success, error) {
        exec(success, error, "Wallet", "start", args);
    };

    stop(args, success, error) {
        exec(success, error, "Wallet", "stop", args);
    };

    createSubWallet(args, success, error) {
        exec(success, error, "Wallet", "createSubWallet", args);
    };

    recoverSubWallet(args, success, error) {
        exec(success, error, "Wallet", "createSubWallet", args);
    };

    createMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMasterWallet", args);
    };

    importWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithKeystore", args);
    };

    importWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "importWalletWithMnemonic", args);
    };

    exportWalletWithKeystore(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithKeystore", args);
    };

    exportWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "exportWalletWithMnemonic", args);
    };

    syncStart(args, success, error) {
        exec(success, error, "Wallet", "syncStart", args);
    };

    syncStop(args, success, error) {
        exec(success, error, "Wallet", "syncStop", args);
    };

    getBalanceInfo(args, success, error) {
        exec(success, error, "Wallet", "getBalanceInfo", args);
    };

    getBalance(args, success, error) {
        exec(success, error, "Wallet", "getBalance", args);
    };

    createAddress(args, success, error) {
        exec(success, error, "Wallet", "createAddress", args);
    };

    getAllAddress(args, success, error) {
        _exec(success, error, "Wallet", "getAllAddress", args);
    };

    getBalanceWithAddress(args, success, error) {
        exec(success, error, "Wallet", "getBalanceWithAddress", args);
    };

    // generateMultiSignTransaction(args, success, error) {
    //     exec(success, error, "Wallet", "generateMultiSignTransaction", args);
    // };

    // createMultiSignAddress(args, success, error) {
    //     exec(success, error, "Wallet", "createMultiSignAddress", args);
    // };

    getAllTransaction(args, success, error) {
        _exec(success, error, "Wallet", "getAllTransaction", args);
    };

    sign(args, success, error) {
        exec(success, error, "Wallet", "sign", args);
    };

    checkSign(args, success, error) {
        exec(success, error, "Wallet", "checkSign", args);
    };

    deriveIdAndKeyForPurpose(args, success, error) {
        exec(success, error, "Wallet", "deriveIdAndKeyForPurpose", args);
    };

    getAllMasterWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllMasterWallets", args);
    };

    registerWalletListener(args, success, error) {
        exec(success, error, "Wallet", "registerWalletListener", args);
    };

    isAddressValid(args, success, error) {
        exec(success, error, "Wallet", "isAddressValid", args);
    };

    generateMnemonic(args, success, error) {
        exec(success, error, "Wallet", "generateMnemonic", args);
    };

    getWalletId(args, success, error) {
        exec(success, error, "Wallet", "getWalletId", args);
    };

    getAllChainIds(args, success, error) {
        exec(success, error, "Wallet", "getAllChainIds", args);
    };

    getSupportedChains(args, success, error) {
        exec(success, error, "Wallet", "getSupportedChains", args);
    };

    getAllSubWallets(args, success, error) {
        _exec(success, error, "Wallet", "getAllSubWallets", args);
    };

    changePassword(args, success, error) {
        exec(success, error, "Wallet", "changePassword", args);
    };

    sendRawTransaction(args, success, error) {
        exec(success, error, "Wallet", "sendRawTransaction", args);
    };

    createTransaction(args, success, error) {
        exec(success, error, "Wallet", "createTransaction", args);
    };

    createDID(args, success, error) {
        exec(success, error, "Wallet", "createDID", args);
    };

    getDIDList(args, success, error) {
        exec(success, error, "Wallet", "getDIDList", args);
    };

    destoryDID(args, success, error) {
        exec(success, error, "Wallet", "destoryDID", args);
    };

    destroyWallet(args, success, error) {
        exec(success, error, "Wallet", "destroyWallet", args);
    };

    createIdTransaction(args, success, error) {
        exec(success, error, "Wallet", "createIdTransaction", args);
    };

    getResolveDIDInfo(args, success, error) {
        exec(success, error, "Wallet", "getResolveDIDInfo", args);
    };

    getAllDID(args, success, error) {
        exec(success, error, "Wallet", "getAllDID", args);
    };

    didSign(args, success, error) {
        exec(success, error, "Wallet", "didSign", args);
    };

    didSignDigest(args, success, error) {
        exec(success, error, "Wallet", "didSignDigest", args);
    };

    verifySignature(args, success, error) {
        exec(success, error, "Wallet", "verifySignature", args);
    };

    getPublicKeyDID(args, success, error) {
        exec(success, error, "Wallet", "getPublicKeyDID", args);
    };

    generateDIDInfoPayload(args, success, error) {
        exec(success, error, "Wallet", "generateDIDInfoPayload", args);
    };

    createDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createDepositTransaction", args);
    };

    createWithdrawTransaction(args, success, error) {
        exec(success, error, "Wallet", "createWithdrawTransaction", args);
    };

    getGenesisAddress(args, success, error) {
        exec(success, error, "Wallet", "getGenesisAddress", args);
    };

    didGenerateProgram(args, success, error) {
        exec(success, error, "Wallet", "didGenerateProgram", args);
    };

    getAllCreatedSubWallets(args, success, error) {
        exec(success, error, "Wallet", "getAllCreatedSubWallets", args);
    };

    createMultiSignMasterWalletWithPrivKey(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithPrivKey", args);

    };

    createMultiSignMasterWallet(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWallet", args);

    };

    getMasterWalletBasicInfo(args, success, error) {
        _exec(success, error, "Wallet", "getMasterWalletBasicInfo", args);
    };

    signTransaction(args, success, error) {
        exec(success, error, "Wallet", "signTransaction", args);
    };

    publishTransaction(args, success, error) {
        _exec(success, error, "Wallet", "publishTransaction", args);
    };

    // getMasterWalletPublicKey(args, success, error) {
    //     exec(success, error, "Wallet", "getMasterWalletPublicKey", args);
    // };

    // getSubWalletPublicKey(args, success, error) {
    //     exec(success, error, "Wallet", "getSubWalletPublicKey", args);
    // };

    createMultiSignMasterWalletWithMnemonic(args, success, error) {
        exec(success, error, "Wallet", "createMultiSignMasterWalletWithMnemonic", args);
    };

    removeWalletListener(args, success, error) {
        exec(success, error, "Wallet", "removeWalletListener", args);
    };

    disposeNative(args, success, error) {
        exec(success, error, "Wallet", "disposeNative", args);
    };

    // getMultiSignPubKeyWithMnemonic(args, success, error) {
    //     exec(success, error, "Wallet", "getMultiSignPubKeyWithMnemonic", args);
    // };

    // getMultiSignPubKeyWithPrivKey(args, success, error) {
    //     exec(success, error, "Wallet", "getMultiSignPubKeyWithPrivKey", args);
    // };

    getTransactionSignedSigners(args, success, error) {
        _exec(success, error, "Wallet", "getTransactionSignedSigners", args);
    };

    // importWalletWithOldKeystore(args, success, error) {
    //     exec(success, error, "Wallet", "importWalletWithOldKeystore", args);
    // };

    getVersion(args, success, error) {
        exec(success, error, "Wallet", "getVersion", args);
    };

    destroySubWallet(args, success, error) {
        exec(success, error, "Wallet", "destroySubWallet", args);
    };

    getVotedProducerList(args, success, error) {
        exec(success, error, "Wallet", "getVotedProducerList", args);
    };

    createVoteProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createVoteProducerTransaction", args);
    };

    createCancelProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createCancelProducerTransaction", args);
    };

    getRegisteredProducerInfo(args, success, error) {
        exec(success, error, "Wallet", "getRegisteredProducerInfo", args);
    };

    createRegisterProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRegisterProducerTransaction", args);
    };

    generateProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateProducerPayload", args);
    };

    generateCancelProducerPayload(args, success, error) {
        exec(success, error, "Wallet", "generateCancelProducerPayload", args);
    };

    getPublicKeyForVote(args, success, error) {
        exec(success, error, "Wallet", "getPublicKeyForVote", args);
    };

    createRetrieveDepositTransaction(args, success, error) {
        exec(success, error, "Wallet", "createRetrieveDepositTransaction", args);
    };

    createUpdateProducerTransaction(args, success, error) {
        exec(success, error, "Wallet", "createUpdateProducerTransaction", args);
    };
}

var walletManager = new WalletManagerImpl();
export = walletManager;