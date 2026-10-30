
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color primary = Color(0xFF4635CB);
const Color bg = Color(0xFFF6F5FC);
const Color dark = Color(0xFF17152B);

class Task {
  String title;
  String subject;
  DateTime dueDate;
  String description;

  Task({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
  });
}

String formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: dark,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= HOME SCREEN =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
    Task(
      title: 'Algebra Worksheet 5',
      subject: 'Math',
      dueDate: DateTime(2026, 10, 30),
      description: 'Solve problems 1-20 on page 84.',
    ),
    Task(
      title: 'Lab Report: Photosynthesis',
      subject: 'Science',
      dueDate: DateTime(2026, 11, 2),
      description: 'Write a lab report about photosynthesis.',
    ),
    Task(
      title: 'Essay: My Hometown',
      subject: 'English',
      dueDate: DateTime(2026, 11, 5),
      description: 'Write an essay about my hometown.',
    ),
  ];

  Future<void> openForm({Task? task}) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(task: task),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (task == null) {
        tasks.add(result);
      } else {
        final index = tasks.indexOf(task);
        if (index != -1) {
          tasks[index] = result;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task == null
              ? 'Task saved successfully'
              : 'Task updated successfully',
        ),
        backgroundColor: dark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> openDetails(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }

  Future<void> deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('Delete Task?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this task? '
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    setState(() {
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted successfully'),
        backgroundColor: dark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color subjectColor(String subject) {
    final value = subject.toLowerCase();

    if (value.contains('math')) {
      return const Color(0xFFE7E3FF);
    }
    if (value.contains('science')) {
      return const Color(0xFFD9F7E9);
    }
    if (value.contains('english')) {
      return const Color(0xFFFFE8D8);
    }

    return const Color(0xFFE9EAF8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                24, 48, 24, 28,
              ),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MyTask',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tasks.length} tasks to finish',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Color(0xFFAAA5CF),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tasks yet. Add your first task!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF77738F),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => openDetails(task),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    crossAxisAlignment:
                                    WrapCrossAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: subjectColor(
                                            task.subject,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          task.subject,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 13,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            formatDate(task.dueDate),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit Task',
                              onPressed: () => openForm(task: task),
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: primary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFF0EDFF),
                              ),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              tooltip: 'Delete Task',
                              onPressed: () => deleteTask(task),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFFFEEEE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openForm(),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

// ================= TASK DETAILS =================

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  color: primary,
                  size: 35,
                ),
                const SizedBox(height: 18),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Subject',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  task.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 35),
                const Text(
                  'Due Date',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  formatDate(task.dueDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 35),
                const Text(
                  'Description',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  task.description.trim().isEmpty
                      ? 'No description added.'
                      : task.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= ADD / EDIT FORM =================

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController subjectController;
  late final TextEditingController descriptionController;

  DateTime? selectedDate;
  bool dateError = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.task?.title ?? '',
    );
    subjectController = TextEditingController(
      text: widget.task?.subject ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    selectedDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateError = false;
      });
    }
  }

  void saveTask() {
    final valid = formKey.currentState!.validate();

    setState(() {
      dateError = selectedDate == null;
    });

    if (!valid || selectedDate == null) return;

    final task = Task(
      title: titleController.text.trim(),
      subject: subjectController.text.trim(),
      dueDate: selectedDate!,
      description: descriptionController.text.trim(),
    );

    Navigator.pop(context, task);
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9995AD),
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFC7C3DD),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        top: 18,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    fieldLabel('Task Title'),
                    TextFormField(
                      controller: titleController,
                      decoration: inputDecoration(
                        'e.g. Algebra Worksheet 5',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    fieldLabel('Subject'),
                    TextFormField(
                      controller: subjectController,
                      decoration: inputDecoration('e.g. Math'),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    fieldLabel('Due Date'),
                    InkWell(
                      onTap: pickDate,
                      child: InputDecorator(
                        decoration: inputDecoration(
                          'Select due date',
                        ).copyWith(
                          errorText: dateError
                              ? 'Please pick a due date'
                              : null,
                          suffixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                          ),
                        ),
                        child: Text(
                          selectedDate == null
                              ? 'Select due date'
                              : formatDate(selectedDate!),
                          style: TextStyle(
                            color: selectedDate == null
                                ? const Color(0xFF9995AD)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    fieldLabel('Description (optional)'),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: inputDecoration(
                        'Add notes about this task',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: saveTask,
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        isEditing
                            ? 'Save Changes'
                            : 'Save Task',
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
