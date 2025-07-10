import 'package:flutter/foundation.dart';
import '../models/faq_item.dart';

class FaqController extends ChangeNotifier {
  final List<FaqItem> _items = [
    FaqItem(
      question: 'How can I save a job I’m interested in?',
      answer:
      'Tap the “Save” icon on the job listing. You can find your saved jobs in the Favorites section.',
    ),
    FaqItem(
      question: 'Where can I find document templates for my application?',
      answer:
      'Go to the Document Templates section in the main menu. You’ll find templates for CVs, cover letters, and other documents.',
    ),
    FaqItem(
      question: 'Can I edit my application after submitting it?',
      answer:
      'Unfortunately, once your application is submitted, you can’t edit it. Please contact us if you need to correct something.',
    ),
    FaqItem(
      question: 'How do I contact support if I have a question?',
      answer:
      'Blablabla',
    ),
    FaqItem(
      question: 'Where can I check the status of my application?',
      answer:
      'Blablabla',
    ),
  ];

  List<FaqItem> get items => List.unmodifiable(_items);

  void toggle(int index) {
    _items[index].isExpanded = !_items[index].isExpanded;
    notifyListeners();
  }
}
