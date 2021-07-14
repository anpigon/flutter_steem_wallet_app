class StringUtil {
  static String truncate(String str, int maxWidth) {
    var result = str.replaceAll(RegExp(r'[\n|\s]+'), ' ').trim();
    if (result.length < maxWidth) return result;
    return result.substring(0, maxWidth);
  }

  static String stripAll(String text) {
    return stripUrl(stripMarkdown(stripHtml(text)));
  }

  static String stripUrl(String text) {
    return text.replaceAll(
        RegExp(
            r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
        '');
  }

  // ref: https://api.flutter.dev/flutter/intl/Bidi/stripHtmlIfNeeded.html
  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  /// ref: https://github.com/stiang/remove-markdown/blob/master/index.js
  static String stripMarkdown(String? md) {
    var output = md ?? '';
    try {
      output = output
          .replaceAll(
              RegExp(r'^(-\s*?|\*\s*?|_\s*?){3,}\s*$', multiLine: true), '')
          .replaceAllMapped(
              RegExp(r'^([\s\t]*)([\*\-\+\>]|\d+\.)\s+', multiLine: true),
              (Match m) => m[1] ?? '')
          // Header
          .replaceAll(RegExp(r'\n={2,}'), '\n')
          // Fenced codeblocks
          .replaceAll(RegExp(r'~{3}.*\n'), '')
          // Strikethrough
          .replaceAll(RegExp(r'~~'), '')
          // Fenced codeblocks
          .replaceAll(RegExp(r'`{3}.*\n'), '')
          // Remove HTML tags
          .replaceAll(RegExp(r'<[^>]*>'), '')
          // Remove setext-style headers
          .replaceAll(RegExp(r'^[=\-]{2,}\s*$'), '')
          // Remove footnotes?
          .replaceAll(RegExp(r'\[\^.+?\](\: .*?$)?'), '')
          .replaceAll(RegExp(r'\s{0,2}\[.*?\]: .*?$'), '')
          // Remove images
          .replaceAll(RegExp(r'\!\[(.*?)\][\[\(].*?[\]\)]'), '')
          // Remove inline links
          .replaceAllMapped(
              RegExp(r'\[(.*?)\][\[\(].*?[\]\)]'), (Match m) => m[1] ?? '')
          // Remove blockquotes
          .replaceAll(RegExp(r'^\s{0,3}>\s?'), '')
          // Remove reference-style links?
          .replaceAll(RegExp(r'^\s{1,2}\[(.*?)\]: (\S+)( ".*?")?\s*$'), '')
          // Remove atx-style headers
          .replaceAllMapped(
              RegExp(
                  r'^(\n)?\s{0,}#{1,6}\s+| {0,}(\n)?\s{0,}#{0,} {0,}(\n)?\s{0,}$',
                  multiLine: true),
              (Match m) => '${m[1] ?? ''}${m[2] ?? ''}${m[3] ?? ''}')
          // Remove emphasis (repeat the line to remove double emphasis)
          .replaceAllMapped(
              RegExp(r'([\*_]{1,3})(\S.*?\S{0,1})\1'), (Match m) => m[2] ?? '')
          .replaceAllMapped(
              RegExp(r'([\*_]{1,3})(\S.*?\S{0,1})\1'), (Match m) => m[2] ?? '')
          // Remove code blocks
          .replaceAllMapped(RegExp(r'/(`{3,})(.*?)\1', multiLine: true),
              (Match m) => m[2] ?? '')
          // Remove inline code
          .replaceAllMapped(RegExp(r'`(.+?)`'), (Match m) => m[1] ?? '')
          // Replace two or more newlines with exactly two? Not entirely sure this belongs here...
          .replaceAll(RegExp(r'\n{2,}'), '\n\n');
      return output;
    } catch (ex, stack) {
      print(ex);
      print(stack.toString());
    }
    return output;
  }

  String removeAllHtmlTags(String htmlText) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
