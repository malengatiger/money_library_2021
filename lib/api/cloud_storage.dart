CloudStorageBloc cloudStorageBloc = CloudStorageBloc();

class CloudStorageBloc {
  // static const CLOUD_STORAGE_PATH = 'stokkie';
  //
  // StreamController<List<StorageTaskEvent>> _storageTaskEvents =
  //     StreamController.broadcast();
  // List<StorageTaskEvent> _events = List();
  //
  // Stream<List<StorageTaskEvent>> get storageTaskEventStream =>
  //     _storageTaskEvents.stream;
  //
  // StreamController<List<String>> _urlController = StreamController.broadcast();
  // List<String> _urls = List();
  //
  // Stream<List<String>> get urlStream => _urlController.stream;
  //
  // var meta = StorageMetadata(cacheControl: '36000');
  //
  // Future<String> uploadFile(File file) async {
  //   print(
  //       'πΌπΌ CloudStorageBlocL uploadFile: πΌ ${file.path} ... starting upload ....');
  //   assert(file != null);
  //   String mimeType = mime(file.path);
  //   print('πΌπΌ CloudStorageBlocL uploadFile: πΌ mimeType: $mimeType');
  //   StorageReference _storageReference = FirebaseStorage().ref().child(
  //       CLOUD_STORAGE_PATH +
  //           '/${DateTime.now().toUtc().millisecondsSinceEpoch}.jpg');
  //   var isSignedIn = await Auth.checkAuthenticated();
  //   print(
  //       'πΌπΌ CloudStorageBlocL uploadFile: πΌ ... starting storageReference.putFile(file) ....isSignedIn: $isSignedIn');
  //   final StorageUploadTask uploadTask = _storageReference.putFile(file);
  //   final StreamSubscription<StorageTaskEvent> streamSubscription =
  //       uploadTask.events.listen((event) {
  //     _events.add(event);
  //     _storageTaskEvents.sink.add(_events);
  //   });
  //
  //   print('π¦  π¦  π¦  StorageUploadTask ... waiting for completion ...');
  //   var snapshot = await uploadTask.onComplete;
  //   streamSubscription.cancel();
  //   var url = await snapshot.ref.getDownloadURL();
  //   _urls.add(url);
  //   _urlController.sink.add(_urls);
  //   print(
  //       'π¦  π¦  π¦  StorageUploadTask returning url after put in stream: π΅ π΅ π΅ $url');
  //   return url;
  // }

  void close() {
    // _storageTaskEvents.close();
    // _urlController.close();
  }
}
