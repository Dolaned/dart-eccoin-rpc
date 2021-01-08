class RPCException implements Exception {
  String error;
  String errorMsg;
  String method;
  List params;

  var ERROR_CODES = {
    // # Standard JSON-RPC 2.0 errors
    -32600: 'RpcInvalidRequest',
    -32601: 'RpcMethodNotFound',
    -32602: 'RpcInvalidParams',
    -32603: 'RpcInternalError',
    -32700: 'RpcParseError',
    // # General application defined errors
    -1: 'RpcMiscError',
    -2: 'RpcForbiddenBySafeMode',
    -3: 'RpcTypeError',
    -5: 'RpcInvalidAddressOrKey',
    -7: 'RpcOutOfMemory',
    -8: 'RpcInvalidParameter',
    -20: 'RpcDatabaseError',
    -22: 'RpcDeserialisationError',
    -25: 'RpcVerifyError',
    -26: 'RpcVerifyRejected',
    -27: 'RpcVerifyAlreadyInChain',
    -28: 'RpcInWarmUp',
    // # P2P client errors
    -9: 'RpcClientNotConnected',
    -10: 'RpcClientInInitialDownload',
    -23: 'RpcClientNodeAlreadyAdded',
    -24: 'RpcClientNodeNotAdded',
    -29: 'RpcClientNotConnected',
    -30: 'RpcClientInvalidIpOrsubnet',
    -31: 'RpcClientP2pDisabled',
    // # Wallet Errors
    -4: 'RpcWalletError',
    -6: 'RpcWalletInsufficientFunds',
    -11: 'RpcWalletInvalidAccountName',
    -12: 'RpcWalletKeypoolRanOut',
    -13: 'RpcWalletUnlockNeeded',
    -14: 'RpcWalletPassphraseIncorrect',
    -15: 'RpcWalletWrongEncState',
    -16: 'RpcWalletEncryptionFailed',
    -17: 'RpcWalletAlreadyUnlocked'
  };

  RPCException({this.error, this.method, this.params}) {
    errorMsg = ERROR_CODES[error];
  }

  String get rpcError {
    return ERROR_CODES[error];
  }

  @override
  String toString() {
    return '$error : $rpcError';
  }
}
