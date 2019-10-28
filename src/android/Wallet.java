 /*
  * Copyright (c) 2018 Elastos Foundation
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

  package org.elastos.trinity.plugins.wallet;


  import org.elastos.spvcore.IMasterWallet;
  import org.elastos.spvcore.ISubWallet;
  import org.elastos.spvcore.IMainchainSubWallet;
  import org.elastos.spvcore.IIDChainSubWallet;
  import org.elastos.spvcore.ISidechainSubWallet;
  import org.elastos.spvcore.ISubWalletCallback;
  import org.elastos.spvcore.MasterWalletManager;
  import org.elastos.spvcore.DIDManagerSupervisor;
  import org.elastos.spvcore.IDidManager;
  import org.elastos.spvcore.IDid;
  import org.elastos.spvcore.IIdManagerCallback;
  import org.elastos.spvcore.WalletException;
  import org.elastos.trinity.runtime.TrinityPlugin;


  import org.apache.cordova.CordovaInterface;
  import org.apache.cordova.CallbackContext;
  import org.apache.cordova.CordovaWebView;
  import org.apache.cordova.PluginResult;

  import org.json.JSONArray;
  import org.json.JSONException;
  import org.json.JSONObject;

  import java.io.FileOutputStream;
  import java.io.InputStream;
  import java.io.OutputStream;
  import java.util.ArrayList;
  import java.util.HashMap;
  import java.util.Map;
  import android.util.Log;


  /**
   * wallet webview jni
   */
  public class Wallet extends TrinityPlugin {

	  //	static {
	  //		System.loadLibrary("spvsdk");
	  //		System.loadLibrary("elastoswallet");
	  //	}

	  private static final String TAG = "Wallet";

	  private Map<String, IDidManager> mDIDManagerMap = new HashMap<String, IDidManager>();
	  private DIDManagerSupervisor mDIDManagerSupervisor = null;
	  private MasterWalletManager mMasterWalletManager = null;
	  //private IDidManager mDidManager = null;
	  private String mRootPath = null;

	  private String keySuccess   = "success";
	  private String keyError     = "error";
	  private String keyCode      = "code";
	  private String keyMessage   = "message";
	  private String keyException = "exception";

	  private int errCodeParseJsonInAction          = 10000;
	  private int errCodeInvalidArg                 = 10001;
	  private int errCodeInvalidMasterWallet        = 10002;
	  private int errCodeInvalidSubWallet           = 10003;
	  private int errCodeCreateMasterWallet         = 10004;
	  private int errCodeCreateSubWallet            = 10005;
	  private int errCodeInvalidMasterWalletManager = 10007;
	  private int errCodeImportFromKeyStore         = 10008;
	  private int errCodeImportFromMnemonic         = 10009;
	  private int errCodeSubWalletInstance          = 10010;
	  private int errCodeInvalidDIDManager          = 10011;
	  private int errCodeInvalidDID                 = 10012;
	  private int errCodeActionNotFound             = 10013;

	  private int errCodeWalletException            = 20000;

	  /**
	   * Called when the system is about to start resuming a previous activity.
	   *
	   * @param multitasking		Flag indicating if multitasking is turned on for app
	   */
	  @Override
	  public void onPause(boolean multitasking) {
		  Log.i(TAG, "onPause");
		  // if (mMasterWalletManager != null) {
		  // 	mMasterWalletManager.SaveConfigs();
		  // }
		  super.onPause(multitasking);
	  }

	  /**
	   * Called when the activity will start interacting with the user.
	   *
	   * @param multitasking		Flag indicating if multitasking is turned on for app
	   */
	  @Override
	  public void onResume(boolean multitasking) {
		  Log.i(TAG, "onResume");
		  super.onResume(multitasking);
	  }

	  /**
	   * Called when the activity is becoming visible to the user.
	   */
	  @Override
	  public void onStart() {
		  Log.i(TAG, "onStart");
		  super.onStart();
	  }

	  /**
	   * Called when the activity is no longer visible to the user.
	   */
	  @Override
	  public void onStop() {
		  Log.i(TAG, "onStop");
		  super.onStop();
	  }

	  /**
	   * The final call you receive before your activity is destroyed.
	   */
	  @Override
	  public void onDestroy() {
		  Log.i(TAG, "onDestroy");
		  if (mMasterWalletManager != null) {
			  Map<String, ArrayList<ISubWallet>> subWalletMap = new HashMap<String, ArrayList<ISubWallet>>();
			  ArrayList<IMasterWallet> masterWalletList = mMasterWalletManager.GetAllMasterWallets();
			  for (int i = 0; i < masterWalletList.size(); i++) {
				  IMasterWallet masterWallet = masterWalletList.get(i);
				  subWalletMap.put(masterWallet.GetID(), masterWallet.GetAllSubWallets());
			  }

			  mMasterWalletManager.DisposeNative();

			  for (Map.Entry<String, ArrayList<ISubWallet>> entry : subWalletMap.entrySet()) {
				  Log.i(TAG, "Removing masterWallet[" + entry.getKey() + "]'s callback");
				  ArrayList<ISubWallet> subWallets = entry.getValue();
				  for (int i = 0; i < subWallets.size(); i++) {
					  subWallets.get(i).RemoveCallback();
				  }
			  }
			  mMasterWalletManager = null;
		  }

		  super.onDestroy();
	  }

	  @Override
	  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		  super.initialize(cordova, webView);
		  mRootPath = getConfigPath() + "spv";
		  mMasterWalletManager = new MasterWalletManager(mRootPath);
	  }



	  private String formatWalletName(String masterWalletID) {
		  return masterWalletID;
	  }

	  private String formatWalletName(String masterWalletID, String chainID) {
		  return masterWalletID + ":" + chainID;
	  }

	  private boolean parametersCheck(JSONArray args) throws JSONException {
		  for (int i = 0; i < args.length(); i++) {
			  if (args.isNull(i)) {
				  Log.e(TAG, "arg[" + i + "] = " + args.get(i) + " should not be null");
				  return false;
			  }
		  }

		  return true;
	  }

	  private void exceptionProcess(WalletException e, CallbackContext cc, String msg) throws JSONException {
		  e.printStackTrace();

		  try {
			  JSONObject exceptionJson = new JSONObject(e.GetErrorInfo());
			  long exceptionCode = exceptionJson.getLong("Code");
			  String exceptionMsg = exceptionJson.getString("Message");

			  JSONObject errJson = new JSONObject();
			  errJson.put(keyCode, exceptionCode);
			  errJson.put(keyMessage, msg + ": " + exceptionMsg);
			  if (exceptionJson.has("Data")) {
				  errJson.put("Data", exceptionJson.getInt("Data"));
			  }

			  Log.e(TAG, errJson.toString());
			  cc.error(errJson);
		  } catch (JSONException je) {
			  JSONObject errJson = new JSONObject();

			  errJson.put(keyCode, errCodeWalletException);
			  errJson.put(keyMessage, msg);
			  errJson.put(keyException, e.GetErrorInfo());

			  Log.e(TAG, errJson.toString());

			  cc.error(errJson);
		  }
	  }

	  private void errorProcess(CallbackContext cc, int code, Object msg) {
		  try {
			  JSONObject errJson = new JSONObject();

			  errJson.put(keyCode, code);
			  errJson.put(keyMessage, msg);
			  Log.e(TAG, errJson.toString());

			  cc.error(errJson);
		  } catch (JSONException e) {
			  String m = "Make json error message exception: " + e.toString();
			  Log.e(TAG, m);
			  cc.error(m);
		  }
	  }
 //
 //	 private void successProcess(CallbackContext cc, Object msg) throws JSONException {
 //		 Log.i(TAG, "result => " + msg);
 //		 //Log.i(TAG, "action success");
 //		 cc.success(msg);
 //	 }

	  private IMasterWallet getIMasterWallet(String masterWalletID) {
		  if (mMasterWalletManager == null) {
			  Log.e(TAG, "Master wallet manager has not initialize");
			  return null;
		  }

		  return mMasterWalletManager.GetMasterWallet(masterWalletID);
	  }

	  private ISubWallet getSubWallet(String masterWalletID, String chainID) {
		  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
		  if (masterWallet == null) {
			  Log.e(TAG, formatWalletName(masterWalletID) + " not found");
			  return null;
		  }

		  ArrayList<ISubWallet> subWalletList = masterWallet.GetAllSubWallets();
		  for (int i = 0; i < subWalletList.size(); i++) {
			  if (chainID.equals(subWalletList.get(i).GetChainID())) {
				  return subWalletList.get(i);
			  }
		  }

		  Log.e(TAG, formatWalletName(masterWalletID, chainID) + " not found");
		  return null;
	  }

	  @Override
	  public boolean execute(String action, JSONArray args, CallbackContext cc) {
		  Log.i(TAG, "action => '" + action + "'");
		  try {
			  if (false == parametersCheck(args)) {
				  errorProcess(cc, errCodeInvalidArg, "Parameters contain 'null' value in action '" + action + "'");
				  return false;
			  }
			  switch (action) {
				  case "coolMethod":
					  String message = args.getString(0);
					  this.coolMethod(message, cc);
					  break;
				  case "print":
					  this.print(args.getString(0), cc);
					  break;

				  // Master wallet manager
				  case "getVersion":
					  this.getVersion(args, cc);
					  break;
				  case "generateMnemonic":
					  this.generateMnemonic(args, cc);
					  break;
				  case "getMultiSignPubKeyWithMnemonic":
					  this.getMultiSignPubKeyWithMnemonic(args, cc);
					  break;
				  case "getMultiSignPubKeyWithPrivKey":
					  this.getMultiSignPubKeyWithPrivKey(args, cc);
					  break;
				  case "createMasterWallet":
					  this.createMasterWallet(args, cc);
					  break;
				  case "createMultiSignMasterWallet":
					  this.createMultiSignMasterWallet(args, cc);
					  break;
				  case "createMultiSignMasterWalletWithPrivKey":
					  this.createMultiSignMasterWalletWithPrivKey(args, cc);
					  break;
				  case "createMultiSignMasterWalletWithMnemonic":
					  this.createMultiSignMasterWalletWithMnemonic(args, cc);
					  break;
				  case "getAllMasterWallets":
					  this.getAllMasterWallets(args, cc);
					  break;
				  case "getAllMasterWalletIds":
					  this.getAllMasterWalletIds(args, cc);
					  break;
				  case "getMasterWallet":
					  this.getMasterWallet(args, cc);
					  break;
				  case "importWalletWithKeystore":
					  this.importWalletWithKeystore(args, cc);
					  break;
				  case "importWalletWithOldKeystore":
					  this.importWalletWithOldKeystore(args, cc);
					  break;
				  case "importWalletWithMnemonic":
					  this.importWalletWithMnemonic(args, cc);
					  break;
				  case "exportWalletWithKeystore":
					  this.exportWalletWithKeystore(args, cc);
					  break;
				  case "exportWalletWithMnemonic":
					  this.exportWalletWithMnemonic(args, cc);
					  break;

				  // Master wallet
				  case "getMasterWalletBasicInfo":
					  this.getMasterWalletBasicInfo(args, cc);
					  break;
				  case "getAllSubWallets":
					  this.getAllSubWallets(args, cc);
					  break;
				  case "createSubWallet":
					  this.createSubWallet(args, cc);
					  break;
				  case "destroyWallet":
					  this.destroyWallet(args, cc);
					  break;
				  case "destroySubWallet":
					  this.destroySubWallet(args, cc);
					  break;
				  case "getMasterWalletPublicKey":
					  this.getMasterWalletPublicKey(args, cc);
					  break;
				  case "masterWalletSign":
					  this.masterWalletSign(args, cc);
					  break;
				  case "masterWalletCheckSign":
					  this.masterWalletCheckSign(args, cc);
					  break;
				  case "isAddressValid":
					  this.isAddressValid(args, cc);
					  break;
				  case "getSupportedChains":
					  this.getSupportedChains(args, cc);
					  break;
				  case "changePassword":
					  this.changePassword(args, cc);
					  break;

				  // SubWallet
				  case "getBalanceInfo":
					  this.getBalanceInfo(args, cc);
					  break;
				  case "getBalance":
					  this.getBalance(args, cc);
					  break;
				  case "createAddress":
					  this.createAddress(args, cc);
					  break;
				  case "getAllAddress":
					  this.getAllAddress(args, cc);
					  break;
				  case "getBalanceWithAddress":
					  this.getBalanceWithAddress(args, cc);
					  break;
				  case "createTransaction":
					  this.createTransaction(args, cc);
					  break;
				  case "signTransaction":
					  this.signTransaction(args, cc);
					  break;
				  case "getTransactionSignedSigners":
					  this.getTransactionSignedSigners(args, cc);
					  break;
				  case "publishTransaction":
					  this.publishTransaction(args, cc);
					  break;
				  case "getAllTransaction":
					  this.getAllTransaction(args, cc);
					  break;
				  case "subWalletSign":
					  this.sign(args, cc);
					  break;
				  case "subWalletCheckSign":
					  this.checkSign(args, cc);
					  break;
				  case "getSubWalletPublicKey":
					  this.getSubWalletPublicKey(args, cc);
					  break;
				  case "registerWalletListener":
					  this.registerWalletListener(args, cc);
					  break;
				  case "removeWalletListener":
					  this.removeWalletListener(args, cc);
					  break;

				  // ID chain subwallet
				  case "createIdTransaction":
					  this.createIdTransaction(args, cc);
					  break;

				  // Main chain subwallet
				  case "createDepositTransaction":
					  this.createDepositTransaction(args, cc);
					  break;
				  case "generateProducerPayload":
					  this.generateProducerPayload(args, cc);
					  break;
				  case "generateCancelProducerPayload":
					  this.generateCancelProducerPayload(args, cc);
					  break;
				  case "createRegisterProducerTransaction":
					  this.createRegisterProducerTransaction(args, cc);
					  break;
				  case "createUpdateProducerTransaction":
					  this.createUpdateProducerTransaction(args, cc);
					  break;
				  case "createCancelProducerTransaction":
					  this.createCancelProducerTransaction(args, cc);
					  break;
				  case "createRetrieveDepositTransaction":
					  this.createRetrieveDepositTransaction(args, cc);
					  break;
				  case "getPublicKeyForVote":
					  this.getPublicKeyForVote(args, cc);
					  break;
				  case "createVoteProducerTransaction":
					  this.createVoteProducerTransaction(args, cc);
					  break;
				  case "getVotedProducerList":
					  this.getVotedProducerList(args, cc);
					  break;
				  case "getRegisteredProducerInfo":
					  this.getRegisteredProducerInfo(args, cc);
					  break;

				  // Side chain subwallet
				  case "createWithdrawTransaction":
					  this.createWithdrawTransaction(args, cc);
					  break;
				  case "getGenesisAddress":
					  this.getGenesisAddress(args, cc);
					  break;

				  default:
					  errorProcess(cc, errCodeActionNotFound, "Action '" + action + "' not found, please check!");
					  return false;
			  }
		  } catch (JSONException e) {
			  e.printStackTrace();
			  errorProcess(cc, errCodeParseJsonInAction, "Execute action '" + action + "' exception: " + e.toString());
			  return false;
		  }

		  return true;
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: long feePerKb
	  public void createSubWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  long feePerKb         = args.getLong(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  ISubWallet subWallet = masterWallet.CreateSubWallet(chainID, feePerKb);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeCreateSubWallet, "Create " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  cc.success(subWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create " + formatWalletName(masterWalletID, chainID));
		  }
	  }

	  public void getAllMasterWallets(JSONArray args, CallbackContext cc) throws JSONException {
		  try {

			  ArrayList<IMasterWallet> masterWalletList = mMasterWalletManager.GetAllMasterWallets();
			  JSONArray masterWalletListJson = new JSONArray();

			  for (int i = 0; i < masterWalletList.size(); i++) {
				  masterWalletListJson.put(masterWalletList.get(i).GetID());
			  }
			  cc.success(masterWalletListJson.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get all master wallets");
		  }
	  }

	  public void getAllMasterWalletIds(JSONArray args, CallbackContext cc) throws JSONException {
		  try {
			  String[] allMasterWalletIds = mMasterWalletManager.GetAllMasterWalletIds();

			  if (allMasterWalletIds.length == 0) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Don't have any master wallet");
				  return;
			  }

			  JSONArray allIdJson = new JSONArray();
			  for (int i = 0; i < allMasterWalletIds.length; i++) {
				  allIdJson.put(allMasterWalletIds[i]);
			  }
			  cc.success(allIdJson.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get all master wallet ID");
		  }
	  }

	  // args[0]: String masterWalletID
	  public void getMasterWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID));
		  }
	  }

	  // args[0]: String masterWalletID
	  public void getMasterWalletBasicInfo(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID) + " basic info");
		  }
	  }

	  // args[0]: String masterWalletID
	  public void getAllSubWallets(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  ArrayList<ISubWallet> subWalletList = masterWallet.GetAllSubWallets();

			  JSONArray subWalletJsonArray = new JSONArray();
			  for (int i = 0; i < subWalletList.size(); i++) {
				  subWalletJsonArray.put(subWalletList.get(i).GetChainID());
			  }

			  cc.success(subWalletJsonArray.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + masterWalletID + " all subwallets");
		  }
	  }

	  public void getVersion(JSONArray args, CallbackContext cc) throws JSONException {
		  if (mMasterWalletManager == null) {
			  errorProcess(cc, errCodeInvalidMasterWalletManager, "Master wallet manager has not initialize");
			  return;
		  }

		  String version = mMasterWalletManager.GetVersion();
		  cc.success(version);
	  }

	  // public void saveConfigs(JSONArray args, CallbackContext cc) throws JSONException {
	  // 	if (mMasterWalletManager == null) {
	  // 		errorProcess(cc, errCodeInvalidMasterWalletManager, "Master wallet manager has not initialize");
	  // 		return;
	  // 	}

	  // 	try {
	  // 		mMasterWalletManager.SaveConfigs();
	  // 		cc.success("Configuration files save successfully");
	  // 	} catch(WalletException e) {
	  // 		exceptionProcess(e, cc, "Master wallet manager save configuration files");
	  // 	}
	  // }

	  // args[0]: String language
	  public void generateMnemonic(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String language = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  if (mMasterWalletManager == null) {
			  errorProcess(cc, errCodeInvalidMasterWalletManager, "Master wallet manager has not initialize");
			  return;
		  }

		  try {
			  String mnemonic = mMasterWalletManager.GenerateMnemonic(language);
			  cc.success(mnemonic);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Generate mnemonic in '" + language + "'");
		  }
	  }

	  // args[0]: String mnemonic
	  // args[1]: String phrasePassword
	  public void getMultiSignPubKeyWithMnemonic(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String mnemonic = args.getString(idx++);
		  String phrasePassword = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  if (mMasterWalletManager == null) {
			  errorProcess(cc, errCodeInvalidMasterWalletManager, "Master wallet manager has not initialize");
			  return;
		  }

		  try {
			  String pubKey = mMasterWalletManager.GetMultiSignPubKeyWithMnemonic(mnemonic, phrasePassword);
			  cc.success(pubKey);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get multi sign public key with mnemonic");
		  }
	  }

	  // args[0]: String privKey
	  public void getMultiSignPubKeyWithPrivKey(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String privKey = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  String pubKey = mMasterWalletManager.GetMultiSignPubKeyWithPrivKey(privKey);
			  cc.success(pubKey);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get multi sign public key with private key");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String address
	  public void isAddressValid(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String addr           = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  Boolean valid = masterWallet.IsAddressValid(addr);
			  cc.success(valid.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Check address valid of " + formatWalletName(masterWalletID));
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String mnemonic
	  // args[2]: String phrasePassword
	  // args[3]: String payPassword
	  // args[4]: boolean singleAddress
	  public void createMasterWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String mnemonic       = args.getString(idx++);
		  String phrasePassword = args.getString(idx++);
		  String payPassword    = args.getString(idx++);
		  boolean singleAddress = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.CreateMasterWallet(
					  masterWalletID, mnemonic, phrasePassword, payPassword, singleAddress);

			  if (masterWallet == null) {
				  errorProcess(cc, errCodeCreateMasterWallet, "Create " + formatWalletName(masterWalletID));
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create " + formatWalletName(masterWalletID));
		  }
	  }

	  public void createMultiSignMasterWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;
		  String privKey = null;


		  String masterWalletID = args.getString(idx++);
		  String publicKeys     = args.getString(idx++);
		  int  m = args.getInt(idx++);
		  long timestamp = args.getLong(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.CreateMultiSignMasterWallet(
					  masterWalletID, publicKeys, m, timestamp);

			  if (masterWallet == null) {
				  errorProcess(cc, errCodeCreateMasterWallet, "Create multi sign " + formatWalletName(masterWalletID));
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create multi sign " + formatWalletName(masterWalletID));
		  }
	  }

	  public void createMultiSignMasterWalletWithPrivKey(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String privKey        = args.getString(idx++);
		  String payPassword    = args.getString(idx++);
		  String publicKeys     = args.getString(idx++);
		  int  m = args.getInt(idx++);
		  long timestamp = args.getLong(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.CreateMultiSignMasterWallet(
					  masterWalletID, privKey, payPassword, publicKeys, m, timestamp);

			  if (masterWallet == null) {
				  errorProcess(cc, errCodeCreateMasterWallet, "Create multi sign " + formatWalletName(masterWalletID) + " with private key");
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create multi sign " + formatWalletName(masterWalletID) + " with private key");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String mnemonic
	  // args[2]: String phrasePassword
	  // args[3]: String payPassword
	  // args[4]: String coSignersJson
	  // args[5]: int requiredSignCount
	  public void createMultiSignMasterWalletWithMnemonic(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String mnemonic       = args.getString(idx++);
		  String phrasePassword = args.getString(idx++);
		  String payPassword    = args.getString(idx++);
		  String publicKeys     = args.getString(idx++);
		  int  m = args.getInt(idx++);
		  long timestamp = args.getLong(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.CreateMultiSignMasterWallet(
					  masterWalletID, mnemonic, phrasePassword, payPassword, publicKeys, m, timestamp);

			  if (masterWallet == null) {
				  errorProcess(cc, errCodeCreateMasterWallet, "Create multi sign " + formatWalletName(masterWalletID) + " with mnemonic");
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create multi sign " + formatWalletName(masterWalletID) + " with mnemonic");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void destroySubWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }
			  ISubWallet subWallet = masterWallet.GetSubWallet(chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }


			  masterWallet.DestroyWallet(subWallet);

			  subWallet.RemoveCallback();

			  cc.success("Destroy " + formatWalletName(masterWalletID, chainID) + " OK");
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Destroy " + formatWalletName(masterWalletID, chainID));
		  }
	  }

	  // args[0]: String masterWalletID
	  public void destroyWallet(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  ArrayList<ISubWallet> subWallets = masterWallet.GetAllSubWallets();

			  mMasterWalletManager.DestroyWallet(masterWalletID);

			  for (int i = 0; subWallets != null && i < subWallets.size(); i++) {
				  subWallets.get(i).RemoveCallback();
			  }

			  cc.success("Destroy " + formatWalletName(masterWalletID) + " OK");
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Destroy " + formatWalletName(masterWalletID));
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String keystoreContent
	  // args[2]: String backupPassword
	  // args[3]: String payPassword
	  // args[4]: String phrasePassword
	  public void importWalletWithOldKeystore(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID  = args.getString(idx++);
		  String keystoreContent = args.getString(idx++);
		  String backupPassword  = args.getString(idx++);
		  String payPassword     = args.getString(idx++);
		  String phrasePassword  = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.ImportWalletWithOldKeystore(
					  masterWalletID, keystoreContent, backupPassword, payPassword, phrasePassword);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeImportFromKeyStore, "Import " + formatWalletName(masterWalletID) + " with keystore");
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Import " + formatWalletName(masterWalletID) + " with keystore");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String keystoreContent
	  // args[2]: String backupPassword
	  // args[3]: String payPassword
	  public void importWalletWithKeystore(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID  = args.getString(idx++);
		  String keystoreContent = args.getString(idx++);
		  String backupPassword  = args.getString(idx++);
		  String payPassword     = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.ImportWalletWithKeystore(
					  masterWalletID, keystoreContent, backupPassword, payPassword);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeImportFromKeyStore, "Import " + formatWalletName(masterWalletID) + " with keystore");
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Import " + formatWalletName(masterWalletID) + " with keystore");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String mnemonic
	  // args[2]: String phrasePassword
	  // args[3]: String payPassword
	  // args[4]: boolean singleAddress
	  public void importWalletWithMnemonic(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String mnemonic       = args.getString(idx++);
		  String phrasePassword = args.getString(idx++);
		  String payPassword    = args.getString(idx++);
		  boolean singleAddress = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = mMasterWalletManager.ImportWalletWithMnemonic(
					  masterWalletID, mnemonic, phrasePassword, payPassword, singleAddress);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeImportFromMnemonic, "Import " + formatWalletName(masterWalletID) + " with mnemonic");
				  return;
			  }

			  cc.success(masterWallet.GetBasicInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Import " + formatWalletName(masterWalletID) + " with mnemonic");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String backupPassword
	  // args[2]: String payPassword
	  public void exportWalletWithKeystore(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String backupPassword = args.getString(idx++);
		  String payPassword    = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  String keystore = mMasterWalletManager.ExportWalletWithKeystore(masterWallet, backupPassword, payPassword);

			  cc.success(keystore);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Export " + formatWalletName(masterWalletID) + "to keystore");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String payPassword
	  public void exportWalletWithMnemonic(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String backupPassword = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  String mnemonic = mMasterWalletManager.ExportWalletWithMnemonic(masterWallet, backupPassword);

			  cc.success(mnemonic);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Export " + masterWalletID + " to mnemonic");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void getBalanceInfo(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }
			  cc.success(subWallet.GetBalanceInfo());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " balance info");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: int BalanceType (0: Default, 1: Voted, 2: Total)
	  public void getBalance(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  int balanceType       = args.getInt(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID) + " balance");
				  return;
			  }

			  cc.success(subWallet.GetBalance(balanceType));
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " balance");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void createAddress(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String address = subWallet.CreateAddress();

			  cc.success(address);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create " + formatWalletName(masterWalletID, chainID) + " address");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: int start
	  // args[3]: int count
	  public void getAllAddress(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  int    start          = args.getInt(idx++);
		  int    count          = args.getInt(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }
			  String allAddresses = subWallet.GetAllAddress(start, count);
			  cc.success(allAddresses);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " all addresses");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String address
	  // args[3]: int balanceType (0: Default, 1: Voted, 2: Total)
	  public void getBalanceWithAddress(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String address        = args.getString(idx++);
		  int balanceType       = args.getInt(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String balance = subWallet.GetBalanceWithAddress(address, balanceType);

			  cc.success(balance);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " balance with address");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String toAddress
	  // args[4]: String amount
	  // args[5]: String memo
	  // args[7]: boolean useVotedUTXO
	  public void createTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String toAddress      = args.getString(idx++);
		  String amount         = args.getString(idx++);
		  String memo           = args.getString(idx++);

		  boolean useVotedUTXO  = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return ;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String tx = subWallet.CreateTransaction(fromAddress, toAddress, amount, memo, useVotedUTXO);

			  cc.success(tx);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Create " + formatWalletName(masterWalletID, chainID) + " tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String rawTransaction
	  // args[3]: String payPassword
	  // return:  String txJson
	  public void signTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String rawTransaction = args.getString(idx++);
		  String payPassword    = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String result = subWallet.SignTransaction(rawTransaction, payPassword);
			  cc.success(result);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Sign " + formatWalletName(masterWalletID, chainID) + " tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String txJson
	  public void getTransactionSignedSigners(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String rawTxJson      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String resultJson = subWallet.GetTransactionSignedInfo(rawTxJson);
			  cc.success(resultJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " tx signed signers");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String rawTxJson
	  // return:  String resultJson
	  public void publishTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String rawTxJson      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String resultJson = subWallet.PublishTransaction(rawTxJson);
			  cc.success(resultJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Publish " + formatWalletName(masterWalletID, chainID) + " tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: int start
	  // args[3]: int count
	  // args[4]: String addressOrTxId
	  // return:  String txJson
	  public void getAllTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  int    start          = args.getInt(idx++);
		  int    count          = args.getInt(idx++);
		  String addressOrTxId  = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  String txJson = subWallet.GetAllTransaction(start, count, addressOrTxId);
			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " all tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String message
	  // args[3]: String payPassword
	  public void sign(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String message        = args.getString(idx++);
		  String payPassword    = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  cc.success(subWallet.Sign(message, payPassword));
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " sign");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String publicKey
	  // args[3]: String message
	  // args[4]: String signature
	  public void checkSign(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String publicKey      = args.getString(idx++);
		  String message        = args.getString(idx++);
		  String signature      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  Boolean result = subWallet.CheckSign(publicKey, message, signature);

			  cc.success(result.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " verify sign");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // return:  String publicKey
	  public void getSubWalletPublicKey(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }
			  String pubKey = subWallet.GetPublicKey();

			  cc.success(pubKey);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID, chainID) + " public key");
		  }
	  }

	  // args[0]: String masterWalletID
	  public void getMasterWalletPublicKey(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  String pubKey = masterWallet.GetPublicKey();

			  cc.success(pubKey);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, "Get " + formatWalletName(masterWalletID) + " public key");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String message
	  // args[2]: String payPassword
	  // return:  String result
	  public void masterWalletSign(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String message        = args.getString(idx++);
		  String payPassword    = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  cc.success(masterWallet.Sign(message, payPassword));
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID) + " sign");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String publicKey
	  // args[2]: String message
	  // args[3]: String signature
	  // return:  String resultJson
	  public void masterWalletCheckSign(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String publicKey      = args.getString(idx++);
		  String message        = args.getString(idx++);
		  String signature      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  Boolean ret = masterWallet.CheckSign(publicKey, message, signature);
			  cc.success(ret.toString());
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID) + " verify sign");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void registerWalletListener(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  subWallet.AddCallback(new ISubWalletCallback() {
				  @Override
				  public void OnTransactionStatusChanged(String txId, String status, String desc, int confirms) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnTxStatusChanged => tx: " + txId + ", status: " + status + ", confirms: " + confirms);
					  try {
						  jsonObject.put("txId", txId);
						  jsonObject.put("status", status);
						  jsonObject.put("desc", desc);
						  jsonObject.put("confirms", confirms);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnTransactionStatusChanged");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  @Override
				  public void OnBlockSyncStarted() {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnBlockSyncStarted");
					  try {
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnBlockSyncStarted");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  @Override
				  public void OnBlockSyncProgress(int currentBlockHeight, int estimatedHeight, long lastBlockTime) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnBlockSyncProgress => [" + currentBlockHeight + " / " + estimatedHeight + "]");
					  try {
						  jsonObject.put("currentBlockHeight", currentBlockHeight);
						  jsonObject.put("estimatedHeight", estimatedHeight);
						  jsonObject.put("lastBlockTime", lastBlockTime);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnBlockSyncProgress");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  @Override
				  public void OnBlockSyncStopped() {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnBlockSyncStopped");
					  try {
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnBlockSyncStopped");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  @Override
				  public void OnBalanceChanged(String asset, String balance) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnBalanceChanged => " + balance);
					  try {
						  jsonObject.put("Asset", asset);
						  jsonObject.put("Balance", balance);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnBalanceChanged");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch(JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  /**
				   * @param result is json result
				   */
				  @Override
				  public void OnTxPublished(String hash, String result) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " OnTxPublished => " + hash + ", result: " + result);
					  try {
						  jsonObject.put("hash", hash);
						  jsonObject.put("result", result);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnTxPublished");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

				  public void OnAssetRegistered(String asset, String info) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " asset => " + asset + ", info: " + info);
					  try {
						  jsonObject.put("asset", asset);
						  jsonObject.put("info", info);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnAssetRegistered");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }
				  public void OnConnectStatusChanged(String status) {
					  JSONObject jsonObject = new JSONObject();
					  Log.i(TAG, formatWalletName(masterWalletID, chainID) + " status => " + status);
					  try {
						  jsonObject.put("status", status);
						  jsonObject.put("MasterWalletID", masterWalletID);
						  jsonObject.put("ChaiID", chainID);
						  jsonObject.put("Action", "OnConnectStatusChanged");

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonObject);
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  } catch (JSONException e) {
						  e.printStackTrace();

						  PluginResult pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.toString());
						  pluginResult.setKeepCallback(true);
						  cc.sendPluginResult(pluginResult);
					  }
				  }

			  });
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " add callback");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void removeWalletListener(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }
		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  subWallet.RemoveCallback();

			  cc.success(formatWalletName(masterWalletID, chainID) + " remove listener");
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " remove listener");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String payloadJson
	  // args[4]: String programJson
	  // args[5]: String memo
	  public void createIdTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String payloadJson    = args.getString(idx++);
		  String programJson    = args.getString(idx++);
		  String memo           = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IIDChainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + "' is not instance of IIDChainSubWallet");
				  return;
			  }

			  IIDChainSubWallet idchainSubWallet = (IIDChainSubWallet)subWallet;

			  cc.success(idchainSubWallet.CreateIDTransaction(fromAddress, payloadJson, programJson, memo));
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create ID tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String lockedAddress
	  // args[4]: String amount
	  // args[5]: String sideChainAddress
	  // args[6]: String memo
	  // args[8]: boolean useVotedUTXO
	  public void createDepositTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String lockedAddress  = args.getString(idx++);
		  String amount         = args.getString(idx++);
		  String sideChainAddress = args.getString(idx++);
		  String memo            = args.getString(idx++);
		  boolean useVotedUTXO   = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateDepositTransaction(fromAddress, lockedAddress, amount, sideChainAddress, memo, useVotedUTXO);

			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create deposit tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String publicKey
	  // args[3]: String nodePublicKey
	  // args[4]: String nickName
	  // args[5]: String url
	  // args[6]: String IPAddress
	  // args[7]: long location
	  // args[8]: String payPasswd
	  public void generateProducerPayload(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String publicKey      = args.getString(idx++);
		  String nodePublicKey  = args.getString(idx++);
		  String nickName       = args.getString(idx++);
		  String url            = args.getString(idx++);
		  String IPAddress      = args.getString(idx++);
		  long   location       = args.getLong(idx++);
		  String payPasswd      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String payloadJson = mainchainSubWallet.GenerateProducerPayload(publicKey, nodePublicKey, nickName, url, IPAddress, location, payPasswd);
			  cc.success(payloadJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " generate producer payload");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String publicKey
	  // args[3]: String payPasswd
	  public void generateCancelProducerPayload(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String publicKey      = args.getString(idx++);
		  String payPasswd      = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String payloadJson = mainchainSubWallet.GenerateCancelProducerPayload(publicKey, payPasswd);
			  cc.success(payloadJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " generate cancel producer payload");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String payloadJson
	  // args[4]: String amount
	  // args[5]: String memo
	  // args[7]: boolean useVotedUTXO
	  public void createRegisterProducerTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String payloadJson    = args.getString(idx++);
		  String amount         = args.getString(idx++);
		  String memo           = args.getString(idx++);
		  boolean useVotedUTXO  = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateRegisterProducerTransaction(fromAddress, payloadJson, amount, memo, useVotedUTXO);
			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create register producer tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String payloadJson
	  // args[4]: String memo
	  // args[6]: boolean useVotedUTXO
	  public void createUpdateProducerTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String payloadJson    = args.getString(idx++);
		  String memo           = args.getString(idx++);
		  boolean useVotedUTXO  = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateUpdateProducerTransaction(fromAddress, payloadJson, memo, useVotedUTXO);
			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create update producer tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String payloadJson
	  // args[4]: String memo
	  // args[6]: boolean useVotedUTXO
	  public void createCancelProducerTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String payloadJson    = args.getString(idx++);
		  String memo           = args.getString(idx++);
		  boolean useVotedUTXO  = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateCancelProducerTransaction(fromAddress, payloadJson, memo, useVotedUTXO);
			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create cancel producer tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String amount
	  // args[3]: String memo
	  public void createRetrieveDepositTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String amount        = args.getString(idx++);
		  String memo           = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateRetrieveDepositTransaction(amount, memo);
			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create retrieve deposit tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void getPublicKeyForVote(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String publicKey = mainchainSubWallet.GetOwnerPublicKey();
			  cc.success(publicKey);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " get public key for vote");
		  }
	  }


	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: long   stake
	  // args[4]: String publicKeys JSONArray
	  // args[5]: String memo
	  // args[7]: boolean useVotedUTXO
	  public void createVoteProducerTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);
		  String fromAddress    = args.getString(idx++);
		  String stake          = args.getString(idx++);
		  String publicKeys     = args.getString(idx++);
		  String memo           = args.getString(idx++);
		  boolean useVotedUTXO  = args.getBoolean(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  Log.i(TAG, formatWalletName(masterWalletID, chainID));

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet)subWallet;

			  String txJson = mainchainSubWallet.CreateVoteProducerTransaction(fromAddress, stake, publicKeys, memo, useVotedUTXO);

			  cc.success(txJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create vote producer tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID (only main chain ID 'ELA')
	  public void getVotedProducerList(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;
		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet) subWallet;

			  String list = mainchainSubWallet.GetVotedProducerList();

			  cc.success(list);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " get voted producer list");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID (only main chain ID 'ELA')
	  public void getRegisteredProducerInfo(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;
		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof IMainchainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of IMainchainSubWallet");
				  return;
			  }

			  IMainchainSubWallet mainchainSubWallet = (IMainchainSubWallet) subWallet;
			  String info = mainchainSubWallet.GetRegisteredProducerInfo();

			  cc.success(info);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " get registerd producer info");
		  }
	  }

	  // args[0]: String masterWalletID
	  public void getSupportedChains(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  String[] supportedChains = masterWallet.GetSupportedChains();
			  JSONArray supportedChainsJson = new JSONArray();
			  for (int i = 0; i < supportedChains.length; i++) {
				  supportedChainsJson.put(supportedChains[i]);
			  }

			  cc.success(supportedChainsJson);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID) + " get support chain");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String oldPassword
	  // args[2]: String newPassword
	  public void changePassword(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String oldPassword    = args.getString(idx++);
		  String newPassword    = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  IMasterWallet masterWallet = getIMasterWallet(masterWalletID);
			  if (masterWallet == null) {
				  errorProcess(cc, errCodeInvalidMasterWallet, "Get " + formatWalletName(masterWalletID));
				  return;
			  }

			  masterWallet.ChangePassword(oldPassword, newPassword);
			  cc.success("Change password OK");
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID) + " change password");
		  }
	  }

	  private JSONObject parseOneParam(String key, Object value) throws JSONException {
		  JSONObject jsonObject = new JSONObject();
		  jsonObject.put(key, value);
		  return jsonObject;
	  }

	  private void coolMethod(String message, CallbackContext cc) {
		  if (message != null && message.length() > 0) {
			  cc.success(message);
		  } else {
			  cc.error("Expected one non-empty string argument.");
		  }
	  }

	  public void print(String text, CallbackContext cc) throws JSONException {
		  if (text == null) {
			  cc.error("Text not can be null");
		  } else {
			  //			LogUtil.i(TAG, text);
			  cc.success(parseOneParam("text", text));
		  }
	  }

	  // SidechainSubWallet

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  // args[2]: String fromAddress
	  // args[3]: String amount
	  // args[4]: String mainchainAdress
	  // args[5]: String memo
	  public void createWithdrawTransaction(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID        = args.getString(idx++);
		  String chainID               = args.getString(idx++);
		  String fromAddress           = args.getString(idx++);
		  String amount                = args.getString(idx++);
		  String mainchainAddress      = args.getString(idx++);
		  String memo                  = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof ISidechainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of ISidechainSubWallet");
				  return;
			  }

			  ISidechainSubWallet sidechainSubWallet = (ISidechainSubWallet)subWallet;
			  String tx = sidechainSubWallet.CreateWithdrawTransaction(fromAddress, amount, mainchainAddress, memo);

			  cc.success(tx);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " create withdraw tx");
		  }
	  }

	  // args[0]: String masterWalletID
	  // args[1]: String chainID
	  public void getGenesisAddress(JSONArray args, CallbackContext cc) throws JSONException {
		  int idx = 0;

		  String masterWalletID = args.getString(idx++);
		  String chainID        = args.getString(idx++);

		  if (args.length() != idx) {
			  errorProcess(cc, errCodeInvalidArg, idx + " parameters are expected");
			  return;
		  }

		  try {
			  ISubWallet subWallet = getSubWallet(masterWalletID, chainID);
			  if (subWallet == null) {
				  errorProcess(cc, errCodeInvalidSubWallet, "Get " + formatWalletName(masterWalletID, chainID));
				  return;
			  }

			  if (! (subWallet instanceof ISidechainSubWallet)) {
				  errorProcess(cc, errCodeSubWalletInstance, formatWalletName(masterWalletID, chainID) + " is not instance of ISidechainSubWallet");
				  return;
			  }

			  ISidechainSubWallet sidechainSubWallet = (ISidechainSubWallet)subWallet;

			  String address = sidechainSubWallet.GetGenesisAddress();

			  cc.success(address);
		  } catch (WalletException e) {
			  exceptionProcess(e, cc, formatWalletName(masterWalletID, chainID) + " get genesis address");
		  }
	  }

  }
