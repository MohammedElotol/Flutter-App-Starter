class RemoteException implements Exception {}

class PersistenceException implements Exception {}

class ServerException implements RemoteException {}

class InternetConnectionException implements RemoteException {}

class CacheException implements PersistenceException {}

class FormatException implements RemoteException, PersistenceException {}
