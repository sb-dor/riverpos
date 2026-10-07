final localPaginationUtilProvider = LocalPaginationUtil();

class LocalPaginationUtil {
  final int _paginationPerPage = 20;

  int checkIsListHasMorePageInt<T>({required List<T> list, required int page, int? limitInPage}) {
    // A short page is the last one, so the next read starts over at 1.
    if (list.length < (limitInPage ?? _paginationPerPage)) return 1;
    return page + 1;
  }

  //this fun will check is there more list in pag (returns boolean)
  bool checkIsListHasMorePageBool<T>({required List<T> list, int? limitInPage}) {
    if (list.length < (limitInPage ?? _paginationPerPage)) {
      return false;
    } else {
      return true;
    }
  }
}
