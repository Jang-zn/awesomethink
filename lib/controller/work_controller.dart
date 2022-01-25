
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class WorkController extends GetxController{
  final WorkRepository workRepository = WorkRepository();

  WorkController();

  final  RxList<Work?> _monthlyWorkList = <Work?>[].obs;
  final  RxList<Work?> _weeklyWorkList = <Work?>[].obs;

  get monthlyWorkList => _monthlyWorkList;
  get weeklyWorkList => _weeklyWorkList;
  set weeklyWorkList(value) => _weeklyWorkList;
  set monthlyWorkList(value) => _monthlyWorkList;

  Future<void> getWeeklyWorkList(String? uid) async{
    _weeklyWorkList(await workRepository.getWeeklyWorkList(uid));
  }

  Future<void> getMonthlyWorkList(String? uid, DateTime dateTime) async {
    _monthlyWorkList(await workRepository.getMonthlyWorkList(uid, dateTime));
  }

  Future<void> updateWorkingTimeState(Work? work, int state) async {
    await workRepository.updateWorkingTimeState(work, state);
    await getWeeklyWorkList(work!.userUid);
    await getMonthlyWorkList(work.userUid, DateTime.now());
    update();
  }

  Future<void> updateWork(Work? work) async{
    await workRepository.updateWork(work);
    await getWeeklyWorkList(work!.userUid);
    await getMonthlyWorkList(work.userUid, DateTime.now());
    update();
  }

  Future<void> setWork(Work? work) async{
    await workRepository.setWork(work);
    await getWeeklyWorkList(work!.userUid);
    await getMonthlyWorkList(work.userUid, DateTime.now());
    update();
  }


}
