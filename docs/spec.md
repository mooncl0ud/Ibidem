# IBIDEM Project Specification

## 1. Global Design System

### 1.1 Color Palette
**Primary Colors**
- Day Background: #FFFFFF
- Night Background: #121212

**Text Colors**
- Day Text: #121212
- Night Text: #E0E0E0

**Accent Color**
- Brand Orange: #FF5722

**Semantic Colors**
- Warning Red: #D32F2F
- Shared Green: #4CAF50

**Sticky Note Colors**
- Pastel Yellow: #FFF9C4
- Pastel Pink: #FFCCBC
- Pastel Blue: #B3E5FC

### 1.2 Typography
**Font Family**
- Main: Noto Sans KR
- Serif: Ridibatang

**Text Styles**
- H1: 24sp, Bold
- H2: 18sp, Medium
- Body: 16sp, Regular
- Caption: 12sp, Regular

## 2. Screen Specifications

### 2.1 Splash & Login
- **Logo**: IBIDEM logo centered.
- **Loading**: CircularProgress (Accent Color).
- **Login UI**: Social Buttons (Google, Apple), Guest Link ("로그인 없이 둘러보기").

### 2.2 Main: Library
**Common Header**
- Inbox Icon (with Red Badge), Search Icon.

**Tab 1: Private Library**
- Grid/List view.
- Book Item: Cover (2:3), Progress Bar, Metadata.

**Tab 2: Shared Library**
- Add Button (+).
- Library Card: AvatarStack, Title, New Badge.

### 2.3 Viewer
**Reading Surface**
- Full Screen Webview (EPUB).
- Sticky Anchor (Right Margin).
- Overlay Highlight.

**HUD: Top Bar**
- Back Button, Co-reading Toggle, TOC Icon, Bookmark Icon.

**HUD: Bottom Bar**
- Scrubber, Chapter Info.
- Settings Button (Aa).

### 2.4 Settings Panel
- **Display**: Brightness (Dual Slider), Theme (White, Sepia, Dark, Black).
- **Typography**: Font Family, Font Size, Line Height.
- **Advanced**: Letter Spacing, Word Scale.

### 2.5 Social Interactions
- **Share Sheet**: Preview Card, Friend List, File Option (with Copyright Warning), Send Button.
- **Sticky Note Modal**: Background color, Author Info, Content, Reply Input, Reply List.

### 2.6 Inbox
- Message Card, Attachment Chip, Action Button (Download/Open).

## 3. Technical Specifications

### 3.1 Tech Stack
- **Framework**: Flutter (Dart 3.x)
- **State Management**: Riverpod
- **Local DB**: Isar
- **Backend**: Firebase (Auth, Firestore, Storage, Functions)

### 3.2 Rendering Engine
- `flutter_inappwebview` for EPUB.
- CSS injection for typography.

### 3.3 Data Synchronization
- CFI (Canonical Fragment Identifier).
- Hybrid Strategy for conflict resolution.

### 3.4 Offline-First
- Read from Isar DB.
- SyncQueue for offline writes.

### 3.5 Data Schema (Firestore)
- `users`, `books`, `shared_libraries`.

## 4. UI/UX Design
- **Principles**: Hidden by Default, Analogue Emotion, Responsible Sharing.
- **Interactions**: Page curl, Haptic feedback.
