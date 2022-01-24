
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class TileWorkController extends GetxController{
  final WorkRepository workRepository = WorkRepository();

  TileWorkController(Work? thisWork){
    _work(thisWork);
  }

  final Rx<Work?> _work = Rx<Work?>(Work());

  get work => _work;
  set work(value) => _work;

  Future<void> getThisWork() async{
    _work(await workRepository.getWorkByStartTime(_work.value));
  }


  Future<void> updateWorkingTimeState(Work? work, int state) async {
    await workRepository.updateWorkingTimeState(work, state);
    getThisWork();
  }

  Future<void> updateWork(Work? work) async{
    await workRepository.updateWork(work);
    getThisWork();
  }


}
