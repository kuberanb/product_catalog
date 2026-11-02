// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcome => 'مرحباً';

  @override
  String get continueToCatalog => 'تسجيل الدخول';

  @override
  String get products => 'المنتجات';

  @override
  String get favourites => 'المفضلة';

  @override
  String get noFavourites => 'لا توجد منتجات مفضلة بعد';

  @override
  String get favouritesHint => 'ستظهر هنا المنتجات التي تحفظها في المفضلة.';

  @override
  String get removeFavourite => 'إزالة من المفضلة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get addFavourite => 'إضافة إلى المفضلة';

  @override
  String get allProductsLoaded => 'تم تحميل جميع المنتجات';

  @override
  String get loginFailed => 'تعذر تسجيل الدخول. تحقق من اتصالك وأعد المحاولة.';

  @override
  String get password => 'كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String price(String amount) {
    return '$amount دولار أمريكي';
  }

  @override
  String rating(String value) {
    return 'التقييم $value من 5';
  }

  @override
  String get offline => 'أنت غير متصل بالإنترنت';

  @override
  String get enterPassword => 'أدخل كلمة المرور.';

  @override
  String get secureStorageError => 'تعذر حفظ جلستك بأمان. أعد المحاولة.';

  @override
  String get noProducts => 'لا توجد منتجات. اسحب لأسفل للتحديث.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get cacheError =>
      'تعذر حفظ المنتجات للاستخدام دون إنترنت. أعد المحاولة.';

  @override
  String get sessionError => 'تعذرت استعادة جلستك. أعد المحاولة.';

  @override
  String get credentialsRequired => 'أدخل اسم المستخدم وكلمة المرور.';

  @override
  String get favouriteSaveError => 'تعذر حفظ المنتج في المفضلة. أعد المحاولة.';

  @override
  String get retryImage => 'الصورة غير متاحة. اضغط لإعادة المحاولة.';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get enterUsername => 'أدخل اسم المستخدم.';

  @override
  String get settingsError => 'تعذر حفظ اللغة المفضلة. أعد المحاولة.';

  @override
  String get invalidCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get logoutError => 'تعذر مسح جلستك. أعد محاولة تسجيل الخروج.';

  @override
  String get productsError => 'تعذر تحميل المنتجات. أعد المحاولة.';

  @override
  String get favouritesError => 'تعذر تحميل المفضلة. أعد المحاولة.';

  @override
  String get demoCredentials => 'حساب تجريبي: emilys / emilyspass';

  @override
  String get searchHint => 'البحث عن منتجات';

  @override
  String get productCode => 'رمز المنتج أو رقمه';

  @override
  String get findProduct => 'البحث عن المنتج';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get search => 'البحث';

  @override
  String get inStock => 'متوفر';

  @override
  String get noSearchResults => 'لا توجد منتجات مطابقة. جرّب بحثاً آخر.';

  @override
  String get enterCode => 'أدخل رمز المنتج أو رقمه.';

  @override
  String get scanner => 'الماسح';

  @override
  String get searchError => 'تعذر البحث عن المنتجات. أعد المحاولة.';

  @override
  String get codeHint => 'catalogue://product/3';

  @override
  String get description => 'الوصف';

  @override
  String get detailsError => 'تعذر تحميل تفاصيل المنتج. أعد المحاولة.';

  @override
  String get searchPrompt => 'ابحث باسم المنتج أو بكلمة مفتاحية.';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get startCamera => 'تشغيل الكاميرا';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get availability => 'التوفر';

  @override
  String get scannerHint =>
      'امسح رمز QR الخاص بالمنتج لفتح تفاصيله. يمكنك أيضاً كتابة رمز مثل catalogue://product/3.';

  @override
  String get category => 'الفئة';

  @override
  String get cameraError =>
      'الكاميرا غير متاحة. اسمح بالوصول إليها في إعدادات الجهاز وأعد المحاولة، أو أدخل الرمز أدناه.';

  @override
  String get noDescription => 'لا يوجد وصف متاح.';

  @override
  String get invalidProductCode => 'رمز QR هذا ليس لمنتج.';

  @override
  String get productNotFound => 'المنتج غير موجود.';

  @override
  String get typeCodeInstead => 'كتابة الرمز بدلاً من ذلك';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get cameraPermissionDenied =>
      'تم رفض إذن الكاميرا. فعّل الوصول إلى الكاميرا في إعدادات التطبيق ثم أعد المحاولة، أو اكتب الرمز بدلاً من ذلك.';

  @override
  String get settingsOpenError =>
      'تعذر فتح الإعدادات. افتح أذونات التطبيق في إعدادات الجهاز أو اكتب الرمز بدلاً من ذلك.';

  @override
  String get language => 'اللغة';

  @override
  String get systemTheme => 'حسب النظام';

  @override
  String get appearance => 'المظهر';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get theme => 'السمة';

  @override
  String get darkTheme => 'داكن';

  @override
  String get themeError => 'تعذر حفظ تفضيل المظهر. أعد المحاولة.';
}
