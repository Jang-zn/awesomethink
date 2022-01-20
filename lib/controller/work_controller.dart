
import 'package:awesomethink/data/model/work.dart';
import 'package:awesomethink/data/repository/work_repo.dart';
import 'package:get/get.dart';

class WorkController extends GetxController{
  final WorkRepository workRepository;

  WorkController({required this.workRepository});

  final _monthlyWorkList = <Work>[].obs;
  final _weeklyWorkList = <Work>[].obs;

  get monthlyWorkList => _monthlyWorkList;
  get weeklyWorkList => _weeklyWorkList;
  set weeklyWorkList(value) => _weeklyWorkList;
  set monthlyWorkList(value) => _monthlyWorkList;

  getWeeklyWorkList(){
    weeklyWorkList = workRepository.getWeeklyWorkList();
  }

  getMonthlylyWorkList(){
    monthlyWorkList = workRepository.getMonthlyWorkList();
  }
}
