import 'package:bitcoinrpc/bitcoinrpc.dart';

void main(List<String> arguments) async {
  dynamic client =
      RPCClient(username: 'yourusername', password: 'yourpassword');
  // print(await client.getInfo);
  // print(await client.getBestBlockHash);
  try {
    var data = await client.getWalletInfo;
    print(data);
  } on HTTPException catch (e) {
    print(e.toString());
    print(e.message);
    print(e.code);
  } on RPCException catch (error) {
    print(error.errorMsg);
  } catch (e) {
    print(e);
  }

  // print(await client.getpeerinfo);
  // print(await client.walletPassPhrase(['P5n-mx2017', '1800']));
  // print(client.help(['hi']));
}
