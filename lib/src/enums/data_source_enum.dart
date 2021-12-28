enum DataSource { localAndRemote, onlyRemote, onlyLocal }

extension DataSourceMapper on DataSource {
  static DataSource? fromString(String dataSource) {
    switch (dataSource) {
      case 'localAndRemote':
        return DataSource.localAndRemote;
      case 'onlyLocal':
        return DataSource.onlyLocal;
      case 'onlyRemote':
        return DataSource.onlyRemote;
      default:
        return null;
    }
  }
}
