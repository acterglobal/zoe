# Font Setup for Zoey

## Typography

Zoey uses the **Inter** font family, specifically designed for user interfaces and digital reading. Inter provides excellent readability for note-taking and content creation apps.

## Automatic Fallbacks

The app automatically falls back to system fonts if Inter is not installed:

- **iOS/macOS**: SF Pro Display, SF Pro Text
- **Windows**: Segoe UI  
- **Android**: Roboto
- **Linux**: Ubuntu
- **Universal fallback**: Arial, sans-serif

## Installing Inter Font (Recommended)

For the best typography experience, install Inter font on your system:

### 📥 Download Inter

1. Visit: https://rsms.me/inter/download/
2. Download the latest version (Inter-4.x.zip)
3. Extract the zip file

### 🖥️ Installation Instructions

#### **macOS**
1. Open the downloaded zip file
2. Install these files by double-clicking and pressing "Install Font":
   - `Inter.ttc` (static fonts)
   - `InterVariable.ttf` (variable font)
   - `InterVariable-Italic.ttf` (variable italic)

#### **Windows**  
1. Right-click the font files and select "Install for all users"
2. Install these files:
   - `Inter.ttc`
   - `InterVariable.ttf` 
   - `InterVariable-Italic.ttf`

#### **Linux**
1. Create fonts directory: `mkdir -p ~/.fonts`
2. Copy fonts: `cp Inter.ttc InterVariable*.ttf ~/.fonts/`
3. Rebuild font cache: `fc-cache -f -v`
4. Restart applications

## Why Inter?

✅ **Screen-optimized**: Designed specifically for digital interfaces  
✅ **Highly readable**: Perfect for long-form note content  
✅ **Clear distinctions**: Easy to distinguish similar characters (0/O, l/1/I)  
✅ **Versatile**: Works beautifully for both headings and body text  
✅ **Open source**: Free to use under SIL Open Font License

## Verify Installation

After installing, restart Zoey to see the improved typography. The font will be automatically applied to:

- Sheet titles and descriptions
- Content block headings  
- Note content and lists
- UI labels and buttons

---

*Inter is designed by Rasmus Andersson and is available under the SIL Open Font License.* 