
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/provider/work_provider.dart';

class WorkRepository{
  List<Work?> currentWork;
  final WorkProvider workProvider;

  WorkRepository({required this.workProvider}){
      _prepareCurrentWork().then((_) {
      logger.d("init WorkProvider : current" + currentWork.toString());
    }
  }
}

