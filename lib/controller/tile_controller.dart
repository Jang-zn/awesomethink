
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class TileController extends GetxController{
  final WorkRepository workRepository = WorkRepository();

  TileController(Work? thisWork){
    _work(thisWork);
  }

  final Rx<Work?> _work = Rx<Work?>(Work());

  get work => _work;
  set work(value) => _work;

  Future<void> getThisWork() async{
    _work(await workRepository.getWorkByStartTime(_work.value));
    refresh();
  }


  Future<void> updateWorkingTimeState(Work? work, int state) async {
    await workRepository.updateWorkingTimeState(work, state);
    await getThisWork();
    print("tileController : "+_work.toString());
  }

  Future<void> updateWork(Work? work) async{
    await workRepository.updateWork(work);
    await getThisWork();
  }


}
