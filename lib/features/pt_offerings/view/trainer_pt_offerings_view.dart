import 'package:flutter/material.dart';
import '../../../features/trainer/model/trainer_model.dart';
import './pt_offerings_list_view.dart';

class TrainerPtOfferingsView extends StatelessWidget {
  final Trainer trainer;

  const TrainerPtOfferingsView({
    super.key,
    required this.trainer,
  });

  @override
  Widget build(BuildContext context) {
    return PtOfferingsListView(
      trainerId: int.parse(trainer.id),
      isTrainerView: false,
    );
  }
}