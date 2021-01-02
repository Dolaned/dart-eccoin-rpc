import '../client.dart';

void main(List<String> arguments) async {
  dynamic client = Client();
  print(await client.getInfo);
  print(await client.getBestBlockHash);
  print(await client.getWalletInfo);
  print(await client.getpeerinfo);
  print(await client.walletPassPhrase(['P5n-mx2017', '1800']));
  // print(client.help(['hi']));
}
