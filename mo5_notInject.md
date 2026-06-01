# 🚨 تقرير الاحتياجات من الباك إند — `mo5_notInject`
**التاريخ:** 24 مايو 2026  
**الهدف:** تحديد كل حاجة التطبيق محتاجها من الباك إند ومش شغالة أو لسه متتربطش

---

## أولاً: كل الـ Endpoints اللي في البوستمان متصلة ✅

أنا دققت على كل endpoint في البوستمان كوليكشن `spider-vendor`، وكلها متصلة في الكود، الحمد لله:

| المجموعة | الـ Endpoint | الحالة |
|---------|------------|--------|
| **Auth** | POST `/api/auth/vendor/register` | ✅ متصل |
| | POST `/api/auth/login` | ✅ متصل |
| | POST `/api/auth/logout` | ✅ متصل |
| | POST `/api/auth/verify-email` | ✅ متصل |
| | POST `/api/auth/verify-phone` | ✅ متصل |
| | POST `/api/auth/resend-verification-code` | ✅ متصل |
| | GET `/api/user` | ✅ متصل |
| **Reset Password** | POST `/api/auth/reset-password/send-code` | ✅ متصل |
| | POST `/api/auth/reset-password/verify-code` | ✅ متصل |
| | POST `/api/auth/reset-password/set-new-password` | ✅ متصل |
| **Home** | GET `/api/vendor/home` | ✅ متصل |
| **Products** | GET `/api/vendor/products` | ✅ متصل |
| | POST `/api/vendor/products` | ✅ متصل (إضافة) |
| | POST `/api/vendor/products/:id` + `_method=PUT` | ✅ متصل (تعديل) |
| | DELETE `/api/vendor/products/:id` | ✅ متصل |
| | POST `/api/vendor/products/:id/toggle-active` | ✅ متصل |
| | GET `/api/vendor/categories` | ✅ متصل |
| | GET `/api/vendor/variants` | ✅ متصل |
| **Orders** | GET `/api/vendor/orders` | ✅ متصل |
| | GET `/api/vendor/orders/:id` | ✅ متصل |
| | GET `/api/vendor/orders/:id/invoice` | ✅ متصل |
| | POST `/api/vendor/orders/:id/update-status` | ✅ متصل |
| **Wallet** | GET `/api/vendor/wallet` | ✅ متصل |
| | GET `/api/wallet/history` | ✅ متصل |
| | POST `/api/vendor/wallet/withdrawals` | ✅ متصل |
| **Branches** | GET `/api/vendor/branches` | ✅ متصل |
| | POST `/api/vendor/branch/toggle-status` | ✅ متصل |
| **Time Slots** | GET `/api/vendor/time-slots` | ✅ متصل |
| | POST `/api/vendor/time-slots` | ✅ متصل |
| | (مش موجود في البوستمان) DELETE | ❌ مش متصل |
| **Ratings** | GET `/api/vendor/ratings` | ✅ متصل |
| **Reports** | GET `/api/vendor/reports/summary?range=` | ✅ متصل |

---

## ثانياً: المشاكل اللي محتاجة شغل من الباك إند 🔴

### 1️⃣ إنشاء منتج — نظام الـ Variations

**المشكلة:**
في بوستمان، إضافة منتج بنوع `variable` بتتبعت بالشكل ده:
```
variations[0][name][en] = "250g / Medium Roast"
variations[0][name][ar] = "250 جم / تحميص متوسط"
variations[0][sku] = "COFFEE-BUNDLE-001-250-MED"
variations[0][price] = 145
variations[0][values][0][variant_id] = 2
variations[0][values][0][option_id] = 4
variations[0][values][1][variant_id] = 2
variations[0][values][1][option_id] = 5
variations[0][branch_stocks][2] = 10
variations[1][name][en] = "500g / Dark Roast"
variations[1][price] = 230
...إلخ
```

**بس التطبيق ببيعت كده:**
```
variants[0] = 2
variants[1] = 3
```

يعني إختلاف كبير في شكل البيانات!

**المطلوب من الباك إند:**
- حدد إنت عاوز تستقبل البيانات بالشكل القديم (variants array IDs) ولا بالشكل الجديد (variations objects كاملة)
- لو عاوز الشكل الجديد، التطبيق هيحتاج يتغير عشان يجمع بيانات كل variation من المستخدم (السعر، SKU، الخيارات، المخزون)
- لو الشكل القديم مقبول، التطبيق شغال خلاص

**السيناريو:**
فيه user stories بـ 3 types من الـ variants (لايت، ميديم، دارك) وكل type ليه option خاص به (تحميص خفيف/وسط/داكن)، والمستخدم في شاشة إضافة صنف بيدي السعر لكل variation و يحدد المخزون بتاعه في كل فرع.

---

### 2️⃣ الـ Branch Stocks مش بتتبعت

**المشكلة:**
في البوستمان، فيه `branch_stocks[2]=25` و `variations[0][branch_stocks][2]=10`، بس التطبيق مش بيبعت الـ branch stocks خالص.

**المطلوب من الباك إند:**
- لو المخزون لكل فرع إجباري عشان المنتج ينضاف، قولي عشان نضيفه في شاشة إضافة صنف
- لو الباك إند بيدي لكل فرع مخزون افتراضي، يبقى مفيش مشكلة

**السيناريو:**
التاجر بيضيف صنف جديد وعاوز يحدد الكمية المتاحة في كل فرع (الفرع الرئيسي, فرع كذا). محتاج UI في شاشة إضافة صنف عشان يختار الفرع ويحط الكمية.

---

### 3️⃣ تعديل البروفايل — مفيش Endpoint خالص

**المشكلة:**
في [profile_page.dart](lib/features/profile/presentation/pages/profile_page.dart) بنعرض بيانات المستخدم من `GET /api/user`. مفيش أي endpoint في البوستمان لتعديل البروفايل (الصورة، الاسم، رقم التليفون).

**المطلوب من الباك إند:**
```
PUT  /api/profile
POST /api/profile (مع _method=PUT عشان multipart)
Headers: Authorization: Bearer {{auth_token}}
Body (form-data):
  owner_name        => "أحمد سالم"
  owner_phone       => "01006573885"
  image             => [ملف صورة]
  name[en]          => "Al-Salem"
  name[ar]          => "السالم"
  address           => "3 makram"

الـ Response المتوقعة:
{
  "success": true,
  "message": "Profile updated successfully.",
  "data": {
    "id": 1,
    "name": "أحمد سالم",
    "email": "vendor@example.com",
    "phone": "01006573885",
    "image": "https://spider.backendpro.site/storage/users/vendor_1.jpg",
    "email_verified_at": "2026-01-15T12:00:00Z",
    "phone_verified_at": null,
    "is_active": true,
    "is_verified": true,
    "created_at": "2026-01-15T12:00:00Z",
    "updated_at": "2026-01-16T12:00:00Z"
  }
}
```

**السيناريو:**
التاجر عاوز يعدل صورته الشخصية أو اسمه أو رقم التليفون من شاشة Profile.

---

### 4️⃣ تغيير باسورد — مفيش Endpoint

**المشكلة:**
في `ApiConstants` عندنا `static const String updatePassword = '/password'` بس مش مستخدم في أي DataSource.

**المطلوب من الباك إند:**
```
POST /api/password
Headers: Authorization: Bearer {{auth_token}}
Body:
{
  "current_password": "oldPass@123",
  "password": "newPass@456",
  "password_confirmation": "newPass@456"
}

الـ Response:
{
  "success": true,
  "message": "Password updated successfully."
}
```

**السيناريو:**
التاجر عاوز يغير باسord من شاشة الإعدادات أو من البروفايل.

---

### 5️⃣ حذف Time Slot

**المشكلة:**
فيه `addTimeSlot` و `updateTimeSlot` فـ [time_slots_remote_datasource.dart](lib/features/time_slots/data/datasources/time_slots_remote_datasource.dart) بس مفيش `deleteTimeSlot`.

**المطلوب من الباك إند:**
```
DELETE /api/vendor/time-slots/:id
Headers: Authorization: Bearer {{auth_token}}

الـ Response:
{
  "success": true,
  "message": "Time slot deleted successfully."
}
```

**السيناريو:**
التاجر فاتح شاشة المواعيد وعاوز يحذف time slot معين (مثلاً يوم الجمعة مقفول).

---

### 6️⃣ تأكيد شكل Response الـ Home

**المشكلة:**
الـ `vendors/home` الـ Response مش موجود في البوستمان. التطبيق بيستخدم [home_stats_model.dart](lib/features/home/data/models/home_stats_model.dart) و [vendor_branch_model.dart](lib/features/my_restaurant/data/models/vendor_branch_model.dart).

**محتاجين تأكيد شكل الـ Response:**
```json
{
  "success": true,
  "data": {
    "total_orders": 150,
    "total_earnings": 25000.50,
    "pending_orders": 12,
    "preparing_orders": 5,
    "ready_orders": 3,
    "delivered_orders": 130,
    "recent_orders": [
      {
        "id": 1,
        "order_code": "ORD-001",
        "customer_name": "محمد علي",
        "total": 150.00,
        "status": "pending",
        "item_count": 3,
        "order_type": "delivery",
        "created_at": "2026-05-24T12:00:00Z"
      }
    ],
    "branch": {
      "id": 1,
      "name": "الفرع الرئيسي",
      "is_open": true,
      "phone": "01006573885",
      "address": "3 makram",
      "image": "https://spider.backendpro.site/storage/branches/1.jpg"
    }
  }
}
```

عشان الـ `recent_orders` بيترجع كأي دي بس، محتاجين كل field عشان الـ Parsing يشتغل صح. الـ `branch` بردو محتاجينه عشان شاشة الهوم تظهر حالة الفتح/القفل.

**السيناريو:**
شاشة الهوم بتظهر إحصائيات واخر الأوردرت وحالة المطعم (مفتوح/مقفول).

---

### 7️⃣ قائمة حالات الأوردر اللي الباك إند بيستخدمها

**المشكلة:**
التطبيق بيستخدم الـ Statuses دي في [order_status.dart](lib/features/orders/domain/entities/order_status.dart):
```
pending, processing, ready_for_pickup, ready_for_delivery, shipped, 
out_for_delivery, delivered, cancelled, returned, refunded
```

وفي الهوم بنفلتر على:
```
ready_for_delivery, pending, cooking, on_the_way
```

**المطلوب:**
تأكيد من الباك إند إيه الـ statuses اللي بتترجع فعلاً في `vendor/orders` و `vendor/home` عشان نتأكد إن الـ Parsing شغال.

بالتحديد:
- هل فيه status إسمه `cooking`؟ التطبيق بيستخدمه في فلتر الهوم
- هل فيه status إسمه `on_the_way`؟ التطبيق بيستخدمه في فلتر الهوم
- هل الـ `shipped` و `out_for_delivery` دول موجودين؟
- هل الـ `returned` و `refunded` دول موجودين؟

> لو الباك إند عنده statuses مختلفة عن اللي في التطبيق، قولي وضيفهم في الـ `OrderStatus` enum.

---

### 8️⃣ تأكيد Response شكل الـ Vendor/Products و الـ Categories

**المشكلة:**
الـ categories ممكن ترجع كـ `tree` structure حسب [restaurant_remote_datasource.dart](lib/features/my_restaurant/data/datasources/restaurant_remote_datasource.dart) سطر 306:
```dart
if (data is Map<String, dynamic> && data['tree'] is List) {
  walkTree(data['tree'] as List);
}
```

**المطلوب:**
تأكيد شكل response categories:
```json
{
  "success": true,
  "data": {
    "tree": [
      {
        "id": 1,
        "name": "مشروبات",
        "children": [
          { "id": 2, "name": "قهوة", "children": [] },
          { "id": 3, "name": "عصائر", "children": [] }
        ]
      }
    ]
  }
}
```

ولو في parent-child hierarchy بردو قولي، عشان نعرف نعمل UI مناسب.

وكمان products response:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": { "en": "Coffee", "ar": "قهوة" },
      "description": { "en": "Hot coffee", "ar": "قهوة ساخنة" },
      "price": 50.00,
      "discount_price": 45.00,
      "category_id": 2,
      "category_name": { "en": "Coffee", "ar": "قهوة" },
      "image": "https://spider.backendpro.site/storage/products/1.jpg",
      "status": "active"
    }
  ]
}
```

---

### 9️⃣ Wallet — شكل Response

**المشكلة:**
مفيش Response example في البوستمان للـ wallet.

**المطلوب:**
```json
{
  "success": true,
  "data": {
    "available_balance": 15000.00,
    "pending_balance": 2000.00,
    "total_withdrawn": 5000.00
  }
}
```

لـ `GET /api/vendor/wallet`

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "amount": 500.00,
      "type": "withdrawal",        // أو "payment" أو "refund"
      "status": "completed",       // pending, completed, failed
      "description": "طلب سحب",
      "created_at": "2026-05-20T12:00:00Z"
    }
  ]
}
```

لـ `GET /api/wallet/history`

**السيناريو:**
التاجر بيفتح شاشة المحفظة عشان يشوف رصيده وتاريخ المعاملات ويطلب سحب.

---

### 🔟 Vendor/Orders Response

**المشكلة:**
مفيش Response example للـ orders في البوستمان.

**المطلوب:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "order_code": "ORD-001",
      "customer_name": "محمد علي",
      "customer_phone": "01001234567",
      "total": 150.00,
      "delivery_fee": 15.00,
      "tax": 7.50,
      "status": "pending",
      "payment_method": "cod",     // cod, card, wallet
      "delivery_address": "3 مكرم عبيد, مدينة نصر",
      "order_type": "delivery",
      "item_count": 3,
      "items": [
        {
          "id": 1,
          "name": "قهوة سادة",
          "quantity": 2,
          "price": 50.00
        }
      ],
      "created_at": "2026-05-24T12:00:00Z"
    }
  ]
}
```

> دا مهم جداً عشان نتأكد إن Parsing الأوردرت شغال صح في [order_model.dart](lib/features/orders/data/models/order_model.dart) و [order_details_model.dart](lib/features/orders/data/models/order_details_model.dart) و [order_summary_model.dart](lib/features/orders/data/models/order_summary_model.dart).

---

### 1️⃣1️⃣ Reports Summary Response

**المشكلة:**
مفيش Response example في البوستمان.

**المطلوب:**
```json
{
  "success": true,
  "data": {
    "total_orders": 250,
    "total_revenue": 50000.00,
    "average_rating": 4.2,
    "total_customers": 180,
    "orders_by_status": {
      "pending": 15,
      "delivered": 220,
      "cancelled": 15
    },
    "revenue_chart": [
      { "label": "2026-04-24", "value": 1500.00 },
      { "label": "2026-04-25", "value": 1800.00 }
    ]
  }
}
```

**السيناريو:**
شاشة التقارير بتعرض إحصائيات و Chart للإيرادات على فترات زمنية (today, yesterday, last_7_days, last_30_days). الـ `revenue_chart` بيحتاج `label` و `value` عشان الرسم البياني يشتغل.

---

### 1️⃣2️⃣ Ratings / Reviews Response

**المشكلة:**
مفيش Response example في البوستمان.

**المطلوب:**
```json
{
  "success": true,
  "data": {
    "average_rating": 4.2,
    "total_reviews": 85,
    "reviews": [
      {
        "id": 1,
        "rating": 5,
        "comment": "اكل حلو جدا",
        "customer_name": "أحمد سعيد",
        "order_id": 15,
        "created_at": "2026-05-20T12:00:00Z"
      }
    ]
  }
}
```

**السيناريو:**
شاشة التقييمات بتعرض متوسط التقييمات وتعليقات العملاء. التطبيق بيقراها من `response.data['data']`.

---

## ثالثاً: Endpoints في الـ Constants بس مش متستخدمة

| الـ Constant | القيمة | الـ Status |
|-------------|--------|-----------|
| `profile` | `/profile` | ❌ معرف في constants بس مش في أي datasource |
| `updatePassword` | `/password` | ❌ معرف في constants بس مش في أي datasource |

---

## رابعاً: حاجات UI محتاجة Endpoints من الباك إند

### أ) تعديل/حذف الصنف — الـ Delete Time Slot
- الـ Time slots عندك Add و Update بس مفيش Delete
- محتاجين `DELETE /api/vendor/time-slots/:id`

### ب) Edit Product — الـ Variations
- التطبيق بيبعت `variants[$i]` (array of IDs)
- البوستمان بيبعت `variations` (objects مع price و sku و stock)
- محتاجين توافق على شكل معين

### ج) Product SKU و Slug
- التطبيق بيجمع SKU و Slug من المستخدم.
- لو الباك إند مش بيستخدمهم، نشيلهم من الشاشة.
- لو بيستخدمهم، نتأكد إنهم مترoqين صح.

---

## الخلاصة — المطلوب من الباك إند بالترتيب 🔥

| الرقم | المطلوب | الأهمية |
|:----:|---------|:-------:|
| 1 | تأكيد شكل **Product Variations** (هل نقدر نبعت `variants[]` IDs ولا محتاج `variations` objects) | 🔴 **حرج** — إضافة صنف مش شغالة |
| 2 | إضافة **PUT /api/profile** لتعديل بيانات التاجر وصورته | 🔴 مطلوب |
| 3 | إضافة **POST /api/password** لتغيير الباسورد | 🟡 مهم |
| 4 | إضافة **DELETE /api/vendor/time-slots/:id** | 🟡 مهم |
| 5 | تأكيد **شكل Response لـ vendor/home** (branch + recent orders) | 🔴 **حرج** — شاشة الهوم |
| 6 | تأكيد **قائمة Order Statuses المتاحة** (خصوصاً `cooking` و `on_the_way`) | 🔴 **حرج** — فلتر الأوردرت |
| 7 | تأكيد **شكل Response لـ vendor/orders** | 🟡 مهم |
| 8 | تأكيد **شكل Response لـ vendor/wallet** و **wallet/history** | 🟡 مهم |
| 9 | تأكيد **شكل Response لـ vendor/reports/summary** | 🟢 عادي |
| 10 | تأكيد **شكل Response لـ vendor/ratings** | 🟢 عادي |
| 11 | هل **Branch Stocks** إجباري في create product؟ | 🟡 مهم |
| 12 | هل الـ **Categories** بترجع كـ `tree` structure؟ | 🟢 عادي |
