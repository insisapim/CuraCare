import 'package:curacare/models/routine_model.dart';
import 'package:curacare/services/routine_service.dart';
import 'package:flutter/material.dart';

class RoutineCard extends StatefulWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.voidCallback,
    required this.openDialog,
  });

  final RoutineModel routine;
  final VoidCallback voidCallback;
  final Function(RoutineModel?) openDialog;

  @override
  State<RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard> {
  final Color kPrimaryGreen = const Color(0xFF2ECC71);
  final Color kSoftGreen = const Color(0xFFE9FBF3);

  void _confirmDelete(RoutineModel item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("ยืนยันการลบ"),
          content: const Text("คุณต้องการลบกิจวัตรนี้ใช่หรือไม่?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await RoutineService.remove(item.id);
                widget.voidCallback.call();

                Navigator.of(ctx).pop();
              },
              child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.routine.isCompleted ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: widget.routine.isCompleted
                ? kPrimaryGreen
                : Colors.grey.shade200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await RoutineService.update(
                    widget.routine.id,
                    widget.routine.title,
                    widget.routine.detail,
                    widget.routine.time,
                    !widget.routine.isCompleted,
                  );
                  widget.voidCallback.call();
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: widget.routine.isCompleted
                        ? kPrimaryGreen
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.routine.isCompleted
                          ? kPrimaryGreen
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: widget.routine.isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.routine.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: widget.routine.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: widget.routine.isCompleted
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${widget.routine.time.format(context)} น.",
                          style: TextStyle(fontSize: 12, color: kPrimaryGreen),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ปุ่มแก้ไข
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => widget.openDialog.call(widget.routine),
              ),
              const SizedBox(width: 8),

              // ปุ่มลบ
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDelete(widget.routine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
