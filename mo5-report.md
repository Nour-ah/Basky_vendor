# Spider Restaurant Vendor - API & UI Mapping Report
**Generated: 2026-05-20**
**Base URL:** `https://spider.backendpro.site/api`

---

## ✅ ENDPOINTS المتصلة فعلاً في الـ UI

### 1. AUTH - AuthCubit
| Endpoint | Method | Screen/Widget | الحالة |
|----------|--------|--------------|--------|
| `/auth/vendor/register` | POST | `RegisterPage` | ✅ متصل |
| `/auth/login` | POST | `LoginPage` | ✅ متصل |
| `/auth/logout` | POST | `HomeDrawer` | ✅ متصل |
| `/auth/verify-email` | POST | `VerifyPhoneScreen` | ✅ متصل |
| `/auth/verify-phone` | POST | `VerifyPhoneScreen` | ✅ متصل |
| `/auth/resend-verification-code` | POST | `VerifyPhoneScreen` | ✅ متصل |
| `/user` | GET | `AuthCubit.getCurrentUser()` | ✅ متصل |

---

### 2. HOME - HomeCubit
| Endpoint | Method | Screen/Widget | الحالة |
|----------|--------|--------------|--------|
| `/vendor/home` | GET | `HomePage` | ✅ متصل |
| - restaurant status toggle | POST | `RestaurantStatusSwitch` | ❓ **محتاج يتربط** |

---

### 3. ORDERS - OrdersCubit
| Endpoint | Method | Screen/Widget | الحالة |
|----------|--------|--------------|--------|
| `/vendor/orders?status=` | GET | `MyOrdersPage` | ✅ متصل |
| `/vendor/orders/:order_id/update-status?status=` | POST | `OrderItemCard` | ✅ متصل |
| `/vendor/orders/:order_id` | GET | Order Details Screen | ❓ **محتاج Screen** |
| `/vendor/orders/:order_id/invoice` | GET | Invoice Screen | ❓ **محتاج Screen** |

---

### 4. MY RESTAURANT - RestaurantCatalogCubit + AddFoodCubit
| Endpoint | Method | Screen/Widget | الحالة |
|----------|--------|--------------|--------|
| `/vendor/categories` | GET | `MyRestaurantPage` | ✅ متصل |
| `/vendor/products` | GET | `MyRestaurantPage` | ✅ متصل |
| `/vendor/products` | POST | `AddFoodPage` | ✅ متصل |
| `/vendor/products/:product_id` (with _method=PUT) | POST | `AddFoodPage` (edit mode) | ❓ **محتاج verify** |
| `/vendor/products/:product_id/toggle-active` | POST | `MenuItemCard` | ❓ **محتاج يتربط** |
| `/vendor/products/:product_id` | DELETE | `MenuItemCard` (delete) | ✅ متصل |
| `/vendor/variants` | GET | `AddFoodPage` | ✅ متصل |

---

### 5. WALLET - WalletCubit
| Endpoint | Method | Screen/Widget | الحالة |
|----------|--------|--------------|--------|
| `/vendor/wallet` | GET | Wallet Screen | ❓ **محتاج Screen** |
| `/wallet/history` | GET | Wallet Screen | ❓ **محتاج Screen** |
| `/vendor/wallet/withdrawals` | POST | Wallet Screen | ❓ **محتاج Screen** |

---

## ❌ ENDPOINTS محتاجة تتربط (في Postman مش في UI)

| Endpoint | Method | الوصف |
|----------|--------|-------|
| `/auth/reset-password/send-code` | POST | نسيت الباسورد - إرسال الكود |
| `/auth/reset-password/verify-code` | POST | نسيت الباسورد - التحقق من الكود |
| `/auth/reset-password/set-new-password` | POST | نسيت الباسورد - تعيين باسورد جديد |
| `/vendor/branches` | GET | قائمة الفروع |
| `/vendor/branches/:branch_id` | GET | تفاصيل فرع معين |
| `/vendor/ratings` | GET | التقييمات والمراجعات |
| `/vendor/time-slots` | GET/POST/PUT | أوقات العمل (إضافة/تعديل/حذف) |
| `/vendor/reports/summary?range=` | GET | التقارير |

---

## 📋 PROMPTS - كل حاجه محتاجة تتعمل

---

### PROMPT 1: شاشة نسيت الباسورد (Forgot Password)

```
أنشئ شاشة Reset Password بالكامل في Flutter:
- 3 خطوات (Steps):
  1. Step 1: EnterEmailScreen - إدخال الإيميل أو التليفون
     → POST /api/auth/reset-password/send-code
     → body: FormData { email: String }
     → على النجاح: انتقل للـ Step 2

  2. Step 2: VerifyCodeScreen - إدخال الكود المرسل
     → POST /api/auth/reset-password/verify-code
     → body: FormData { code: String (6 digits), email: String }
     → على النجاح: انتقل للـ Step 3

  3. Step 3: SetNewPasswordScreen - تعيين باسورد جديد
     → POST /api/auth/reset-password/set-new-password
     → body: FormData { reset_token: String, password: String, password_confirmation: String }
     → على النجاح: رجوع لـ Login

- استخدم Bloc/Cubit لإدارة الـ state
- اعمل Cubit: ResetPasswordCubit
- اعمل States: ResetPasswordInitial, SendingCode, CodeSent, VerifyingCode, CodeVerified, SettingPassword, Success, Error
- اعمل UseCases:
  - SendResetCodeUseCase
  - VerifyResetCodeUseCase
  - SetNewPasswordUseCase
- اعمل Repository + DataSource
- UI: StepIndicator في الأعلى (1-2-3)
- Navigation: استخدم go_router أو manual Navigator
```

**الـ Endpoint المطلوب:**
```
POST /api/auth/reset-password/send-code
POST /api/auth/reset-password/verify-code
POST /api/auth/reset-password/set-new-password
```

---

### PROMPT 2: شاشة تفاصيل الطلب (Order Details)

```
أنشئ شاشة Order Details في Flutter:
- GET /api/vendor/orders/:order_id
  → Response: { order, items[], customer, address, payment_info }

- اعمل:
  - OrderDetailsPage (Screen)
  - OrderDetailsCubit
  - OrderDetailsState
  - GetOrderDetailsUseCase

- UI Components:
  - AppBar مع رقم الطلب (order code)
  - Customer Info Card (الاسم، التليفون)
  - Order Items List (المنتجات المطلوبة)
  - Address Card (عنوان التوصيل)
  - Payment Summary (المجموع، الخصم، التوصيل، النهائي)
  - Order Status Timeline (pending → processing → ready → shipped → delivered)
  - Action Buttons:
    - تحديث الحالة (يستخدم OrdersCubit.updateOrderStatus)
    - طباعة الفاتورة

- Pull to refresh
- Loading state, Error state
```

**الـ Endpoint المطلوب:**
```
GET /api/vendor/orders/:order_id
GET /api/vendor/orders/:order_id/invoice (للفاتورة)
```

---

### PROMPT 3: شاشة الفاتورة (Invoice)

```
أنشئ شاشة Invoice في Flutter:
- GET /api/vendor/orders/:order_id/invoice
  → Response: Invoice object (invoice_number, date, items[], totals, vendor_info, customer_info)

- اعمل:
  - InvoicePage (Screen)
  - InvoiceCubit
  - InvoiceState
  - GetInvoiceUseCase

- UI Components:
  - Vendor Header (اسم المطعم، العنوان، التليفون)
  - Invoice Info (رقم الفاتورة، التاريخ)
  - Customer Details
  - Items Table (المنتج، الكمية، السعر، المجموع)
  - Subtotal, Tax, Discount, Delivery Fee, Grand Total
  - Payment Method
  - Footer (شكراً لطلبك)

- مميزات:
  - Share Invoice (share_plus package)
  - Print Invoice (printing package)
  - Download as PDF
```

**الـ Endpoint المطلوب:**
```
GET /api/vendor/orders/:order_id/invoice
```

---

### PROMPT 4: شاشة المحفظة (Wallet)

```
أنشئ شاشة Wallet في Flutter:
- GET /api/vendor/wallet → بيانات المحفظة
- GET /api/wallet/history → تاريخ المعاملات
- POST /api/vendor/wallet/withdrawals → طلب سحب

- اعمل:
  - WalletPage (Screen)
  - WalletCubit (موجود فعلاً!)
  - WalletStates (موجود فعلاً!)
  - UseCases:
    - GetWalletDetailsUseCase (موجود!)
    - GetWalletHistoryUseCase (موجود!)
    - RequestWithdrawalUseCase (موجود!)

- UI Components:
  - Balance Card (الرصيد الحالي، الربح الكلي، المعلق)
  - Quick Actions (سحب، ملء)
  - Transaction History List
    - TransactionItem: نوع المعاملة، المبلغ، التاريخ، الحالة
    - فلتر: all, deposits, withdrawals
  - طلب سحب:
    - Amount Input
    - Method Selection (cash, bank, etc.)
    - Notes (optional)
    - Submit Button

- Pull to refresh
- Pagination للـ history
- Loading states
```

**الـ Endpoints المطلوبة:**
```
GET /api/vendor/wallet
GET /api/wallet/history
POST /api/vendor/wallet/withdrawals (body: { amount, method, notes })
```

---

### PROMPT 5: شاشة الفروع (Branches)

```
أنشئ شاشة Branches في Flutter:
- GET /api/vendor/branches → قائمة الفروع
- GET /api/vendor/branches/:branch_id → تفاصيل فرع

- اعمل:
  - BranchesPage (Screen)
  - BranchesCubit
  - BranchesState
  - UseCases:
    - GetBranchesUseCase
    - GetBranchDetailsUseCase

- UI Components:
  - Branch List:
    - Branch Card: اسم الفرع، العنوان، التليفون، الحالة (مفتوح/مغلق)
    - Tap على الفرع → Branch Details

  - Branch Details Page:
    - معلومات الفرع كاملة
    - الخريطة (Google Maps)
    - أوقات العمل
    - إحصائيات الفرع (طلبات اليوم، الأرباح)
    - منتجات الفرع
    - تعديل الفرع (Edit Branch)
    - تفعيل/تعطيل الفرع

- FAB: إضافة فرع جديد
  - POST /api/vendor/branches
  - Form: name, address, phone, image, is_active
```

**الـ Endpoints المطلوبة:**
```
GET /api/vendor/branches
GET /api/vendor/branches/:branch_id
POST /api/vendor/branches (إضافة)
PUT /api/vendor/branches/:branch_id (تعديل)
POST /api/vendor/branches/:branch_id/toggle-active (تفعيل/تعطيل)
```

---

### PROMPT 6: شاشة التقييمات (Reviews/Ratings)

```
أنشئ شاشة Reviews في Flutter:
- GET /api/vendor/ratings → قائمة التقييمات

- اعمل:
  - ReviewsPage (Screen)
  - ReviewsCubit
  - ReviewsState
  - GetReviewsUseCase

- UI Components:
  - Overview Card:
    - Average Rating (4.5 ⭐)
    - Total Reviews Count
    - Rating Breakdown (5 stars: 50%, 4 stars: 30%, etc.)

  - Reviews List:
    - Review Card: صورة العميل، الاسم، التاريخ، التقييم (نجوم)، التعليق
    - Order related to review (if exists)
    - Helpful button

  - Filter: All, 5 stars, 4 stars, etc.
  - Sort: Newest, Highest, Lowest

- Pull to refresh
- Pagination (infinite scroll)
```

**الـ Endpoint المطلوب:**
```
GET /api/vendor/ratings
```

---

### PROMPT 7: شاشة أوقات العمل (Time Slots)

```
أنشئ شاشة Time Slots / Opening Hours في Flutter:
- GET /api/vendor/time-slots → جلب الأوقات
- POST /api/vendor/time-slots → إضافة وقت
- PUT /api/vendor/time-slots/:id → تعديل وقت

- اعمل:
  - TimeSlotsPage (Screen)
  - TimeSlotsCubit
  - TimeSlotsState
  - UseCases:
    - GetTimeSlotsUseCase
    - AddTimeSlotUseCase
    - UpdateTimeSlotUseCase
    - DeleteTimeSlotUseCase

- UI Components:
  - Weekly Schedule View:
    - كل يوم (السبت - الجمعة) مع أوقات العمل
    - كل يوم فيه slots متعددة (صباحي، مسائي)
    - Edit/Delete لكل slot

  - Add Time Slot Dialog:
    - Day Selector (السبت - الجمعة)
    - Time Range Picker (opens_at, closes_at)
    - Add Button

  - Quick Actions:
    - Copy to other days
    - Set 24 hours
    - Set closed

- Offline support (cache)
```

**الـ Endpoints المطلوبة:**
```
GET /api/vendor/time-slots
POST /api/vendor/time-slots (body: { day_of_week, opens_at, closes_at })
PUT /api/vendor/time-slots/:id (query: { day_of_week, opens_at, closes_at })
DELETE /api/vendor/time-slots/:id
```

---

### PROMPT 8: شاشة التقارير (Reports)

```
أنشئ شاشة Reports في Flutter:
- GET /api/vendor/reports/summary?range=

- اعمل:
  - ReportsPage (Screen)
  - ReportsCubit
  - ReportsState
  - GetReportsUseCase

- UI Components:
  - Date Range Selector:
    - Today, Last 7 Days, Last 30 Days, Custom

  - Summary Cards:
    - Total Orders
    - Total Revenue
    - Average Order Value
    - Canceled Orders Rate

  - Charts:
    - Orders Over Time (Line Chart)
    - Revenue by Day (Bar Chart)
    - Orders by Status (Pie Chart)

  - Top Products:
    - Best Selling Products List
    - Worst Selling Products

  - Export Options:
    - Export as PDF
    - Export as CSV
    - Share Report

- Pull to refresh
```

**الـ Endpoint المطلوب:**
```
GET /api/vendor/reports/summary?range=last_7_days|last_30_days|this_month|last_month
```

---

### PROMPT 9: تفعيل/تعطيل switch حالة المطعم (Restaurant Status)

```
ربط زر Restaurant Status Switch في HomePage:

- حالياً: الـ widget موجود بس مش متصل بأي API
- محتاج يتربط بـ:

- أولاً، اسأل Backend عن الـ endpoint (مش موجود في Postman):
  → احتمال يكون: POST /api/vendor/restaurant/status
  → أو: PUT /api/vendor/restaurant
  → أو: PATCH /api/vendor/status

- لو الـ endpoint مش موجود، اعمل واحد:
  - طلب من Backend يضيف endpoint
  - أو استخدم workaround: /vendor/home PUT

- اعمل:
  - RestaurantStatusCubit أو استخدم HomeCubit
  - UpdateRestaurantStatusUseCase
  - API: TO BE CONFIRMED WITH BACKEND

- UI:
  - Switch: Restaurant Open/Closed
  - Loading state أثناء التحديث
  - Success/Error feedback
  - Auto-refresh Home stats after change
```

---

### PROMPT 10: تعديل منتج - Edit Product Flow

```
تأكيد ربط Edit Product في AddFoodPage:

- حالياً: AddFoodCubit.submitForm() بـ AddProductUseCase فقط
- محتاج يتربط بـ UpdateProductUseCase

- اعمل:
  - Modify AddFoodCubit:
    - اضيف parameter: int? productId
    - لو productId != null → استخدم UpdateProductUseCase
    - لو productId == null → استخدم AddProductUseCase

  - اعمل UpdateProductUseCase:
    - Repository: UpdateProductRepository
    - DataSource: updateProduct(productId, params)
    - API: POST /api/vendor/products/:product_id (with _method=PUT as form field)

  - في UI:
    - في AddFoodPage، لو جاي من edit mode → اعرض البيانات
    - مخفي في الـ form: _method = "PUT", product_id
```

---

## 📊 ملخص الأعمال المطلوبة

| # | المهمة | الأولوية | الحالة |
|---|--------|----------|--------|
| 1 | Forgot Password Flow | 🔴 عالية | ❌ مش متصل |
| 2 | Order Details Screen | 🔴 عالية | ❌ مش متصل |
| 3 | Invoice Screen | 🟡 متوسطة | ❌ مش متصل |
| 4 | Wallet Screen | 🔴 عالية | ❌ مش متصل |
| 5 | Branches Screen | 🟡 متوسطة | ❌ مش متصل |
| 6 | Reviews Screen | 🟡 متوسطة | ❌ مش متصل |
| 7 | Time Slots Screen | 🟡 متوسطة | ❌ مش متصل |
| 8 | Reports Screen | 🟡 متوسطة | ❌ مش متصل |
| 9 | Restaurant Status Toggle | 🔴 عالية | ❌ مش متصل |
| 10 | Edit Product Flow | 🔴 عالية | ⚠️ محتاج يتأكد |

---

## 🔧 قبل ما تبدأ، اسأل Backend عن:

1. **Restaurant Status Toggle**: إيه الـ endpoint؟
2. **Vendor Branches CRUD**: إيه الـ endpoints للـ create/update/delete؟
3. **Time Slots Delete**: إيه الـ endpoint لحذف time slot؟
4. **Wallet History Pagination**: هل فيه page/per_page parameters؟

---

**End of Report**