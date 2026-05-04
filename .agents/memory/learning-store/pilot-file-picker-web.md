---
id: "ls-2026-0423-pilot-001"
type: "best-practice"
created: "2026-04-23T14:50:00-03:00"
outcome: "positive"
impact_score: 0.85
confidence: 0.9
project_context: "pilot-run"
request_id: "pilot-run-profile-screen"
agents_involved: ["builder", "platform-guardian"]
tags: ["flutter", "web", "file_picker", "upload", "multipart"]
related_memories: ["ls-seed-flutter-001"]
reviewed: true
review_date: "2026-04-23"
---

## Summary
file_picker on Web returns bytes (not file path). Upload must use MultipartFile.fromBytes.

## Context
During profile avatar upload implementation, file_picker was chosen over image_picker
for cross-platform compatibility. It works on all platforms, but the return value differs.

## Decision Made
```dart
// Native platforms (Android, iOS, Windows):
final file = result.files.single;
final multipart = await MultipartFile.fromFile(file.path!);

// Web platform:
final file = result.files.single;
final multipart = MultipartFile.fromBytes(
  file.bytes!,
  filename: file.name,
);

// Universal approach:
final file = result.files.single;
final multipart = file.path != null
    ? await MultipartFile.fromFile(file.path!, filename: file.name)
    : MultipartFile.fromBytes(file.bytes!, filename: file.name);
```

## Lessons Learned
- file_picker on Web uses html.FileUploadInputElement → no file system path
- platformFile.path is null on Web, platformFile.bytes is available
- Always check for null path before using MultipartFile.fromFile
- This pattern applies to ANY file upload on Web, not just avatars

## Conditions for Reuse
Any Flutter project that uploads files and targets Web.
