import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/track_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/services/order_details_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;




class OrderDetailsController with ChangeNotifier {
  final OrderDetailsServiceInterface orderDetailsServiceInterface;
  OrderDetailsController({required this.orderDetailsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDownloaodLoading = false;
  bool get isDownloaodLoading => _isDownloaodLoading;
  int _downloaodIndex = -1;
  int get downloaodIndex => _downloaodIndex;

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  List <XFile?>_refundImage = [];
  List<XFile?> get refundImage => _refundImage;
  List<File> reviewImages = [];
  bool _isInvoiceLoading = false;
  bool get isInvoiceLoading => _isInvoiceLoading;



  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;

  void digitalOnly(bool value, {bool isUpdate = false}){
    _onlyDigital = value;
    if(isUpdate){
      notifyListeners();
    }
  }



  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  TrackOrderDetailsModel? _trackOrderDetailsModel;
  TrackOrderDetailsModel? get trackOrderDetailsModel => _trackOrderDetailsModel;

  // bool isRefundRequestedForOrder(int orderId) {
  //   if (_orderDetails == null || _orderDetails!.isEmpty) return false;
  //
  //   return _orderDetails!.any((orderDetail) => orderDetail.orderId == orderId && orderDetail.refundReq != null && orderDetail.refundReq != 0);
  // }

  Future <ApiResponseModel> getOrderDetails(String orderID) async {
    print("---->>Getting order details for orderID: $orderID");
    _orderDetails = null;
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.getOrderDetails(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = null;
      _orderDetails = [];
      final dynamic itemsData = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (itemsData is List) {
        itemsData.forEach((order) {
          OrderDetailsModel orderDetailsModel = OrderDetailsModel.fromJson(order);
          _orderDetails!.add(orderDetailsModel);
        });
      }
    }
    notifyListeners();
    return apiResponse;
  }

  void emptyOrderDetails() {
    _orderDetails = null;
    orders = null;
    notifyListeners();
  }



  Future <ApiResponseModel> getOrderInvoice(String orderID, context) async {
    _isInvoiceLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.getOrderInvoice(orderID);
    final dynamic body = apiResponse.response?.data;
    final dynamic rawContent = body is Map ? body['content'] : null;
    final dynamic invoiceBytes = body is List ? body : rawContent is List ? rawContent : ApiEnvelope.content(body)['data'];

    if (apiResponse.response?.statusCode == 200 && invoiceBytes is List) {
      await requestPermissions();
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      List<int> intList = List<int>.from(invoiceBytes);

      String fileName = '$orderID.pdf';
      var filePath = path.join(downloadsDirectory.path, '$orderID.pdf');

      int fileCounter = 1;

      while (await File(filePath).exists()) {
        fileName = '$orderID($fileCounter).pdf';
        filePath = path.join(downloadsDirectory.path, fileName);
        fileCounter++;
      }

      final file = File(filePath);
      await file.writeAsBytes(intList);
      await OpenFile.open(filePath);
      showCustomSnackBarWidget(getTranslated('invoice_downloaded_successfully', context), Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(getTranslated('invoice_download_failed', context), Get.context!, snackBarType: SnackBarType.error);
    }
    _isInvoiceLoading = false;
    notifyListeners();
    return apiResponse;
  }




  Orders? orders;
  Future <void> getOrderFromOrderId(String orderID) async {
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.getOrderFromOrderId(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic orderData = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (orderData is Map<String, dynamic>) {
        orders = Orders.fromJson(orderData);
      }
    }
    notifyListeners();
  }



  void pickImage(bool isRemove, {bool fromReview = false}) async {
    if(isRemove) {
      _imageFile = null;
      _refundImage = [];
      reviewImages = [];
    }else {
      _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: AppConstants.imageQuality);
      if (_imageFile != null) {
        if(fromReview){
          reviewImages.add(File(_imageFile!.path));
        }else{
          _refundImage.add(_imageFile);
        }
      }
    }
    notifyListeners();
  }


  void removeImage(int index, {bool fromReview = false}){
    if(fromReview){
      reviewImages.removeAt(index);
    }else{
      _refundImage.removeAt(index);
    }

    notifyListeners();
  }



  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }



  bool searching = false;
  Future<ApiResponseModel> trackOrder({String? orderId, String? phoneNumber, bool isUpdate = true}) async {
    searching = true;
    if(isUpdate) {
      notifyListeners();
    }

    ApiResponseModel apiResponse = await orderDetailsServiceInterface.trackOrder(orderId!, phoneNumber!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      searching = false;
      _orderDetails = [];
      final dynamic itemsData = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (itemsData is List) {
        itemsData.forEach((order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
      }
    } else {
      searching = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponseModel> getTrackOrderDetailsId({String? orderId, String? phoneNumber, bool isUpdate = true}) async {
    searching = true;
    if(isUpdate) {
      notifyListeners();
    }

    ApiResponseModel apiResponse = await orderDetailsServiceInterface.getTrackOrderDetailsId(orderId!, phoneNumber);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      searching = false;
      _trackOrderDetailsModel = null;
      _trackOrderDetailsModel  =  TrackOrderDetailsModel.fromJson(ApiEnvelope.content(apiResponse.response!.data)['data']);
    } else {
      searching = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponseModel> downloadDigitalProduct({int? orderDetailsId}) async {
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.downloadDigitalProduct(orderDetailsId!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Provider.of<AuthController>(Get.context!, listen: false).resendTime = ApiEnvelope.content(apiResponse.response!.data)['time_count_in_second'];
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponseModel> resentDigitalProductOtp({int? orderId}) async {
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.resentDigitalProductOtp(orderId!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponseModel> verifyDigitalProductOtp({required int orderId, required String otp}) async {
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.verifyDigitalProductOtp(orderId, otp);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();

      // v6 streams the file back as raw bytes on success — write it out ourselves
      // instead of the old GET-and-launch-in-browser approach, since verify is a POST.
      await requestPermissions();
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      final List<int> fileBytes = List<int>.from(apiResponse.response!.data);

      String fileName = _digitalProductFileName(apiResponse.response!, orderId);
      var filePath = path.join(downloadsDirectory.path, fileName);
      final String extension = path.extension(fileName);
      final String baseName = path.basenameWithoutExtension(fileName);

      int fileCounter = 1;
      while (await File(filePath).exists()) {
        fileName = '$baseName($fileCounter)$extension';
        filePath = path.join(downloadsDirectory.path, fileName);
        fileCounter++;
      }

      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      await OpenFile.open(filePath);
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  String _digitalProductFileName(Response response, int orderId) {
    final String? contentDisposition = response.headers.value('content-disposition');
    if (contentDisposition != null) {
      final RegExpMatch? match = RegExp('filename\\*?=(?:UTF-8\'\')?"?([^";]+)"?').firstMatch(contentDisposition);
      final String? extracted = match?.group(1);
      if (extracted != null && extracted.trim().isNotEmpty) {
        return Uri.decodeFull(extracted.trim());
      }
    }
    return 'digital_product_$orderId';
  }


  void productDownload({required String url, required String fileName, required int index, bool isIos = false}) async {
    _isDownloaodLoading = true;
    _downloaodIndex = index;
    notifyListeners();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var selectedFolderType = AndroidFolderType.download;
    final subFolderPathCtrl = TextEditingController();


    List<String> fileTypes = [ '.txt', '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.mp3', '.wav', '.ogg', '.m4a', '.aac',
      '.mp4', '.avi', '.mkv', '.webm', '.3gp', '.pdf', '.doc'];


    if(isIos){
     HttpClientResponse apiResponse = await orderDetailsServiceInterface.productDownload(url);
     if (apiResponse.statusCode == 200) {

       List<int> downloadData = [];
       Directory downloadDirectory;

       if (Platform.isIOS) {
         downloadDirectory = await getApplicationDocumentsDirectory();
       } else {
         downloadDirectory = Directory('/storage/emulated/0/Download');
         if (!await downloadDirectory.exists()) downloadDirectory = (await getExternalStorageDirectory())!;
       }

       String filePathName = "${downloadDirectory.path}/$fileName";
       File savedFile = File(filePathName);
       bool fileExists = await savedFile.exists();

       if (fileExists) {
         ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("File already downloaded")));
       } else {
         apiResponse.listen((d) => downloadData.addAll(d), onDone: () {
           savedFile.writeAsBytes(downloadData);
         });
         showCustomSnackBarWidget(getTranslated('product_downloaded_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
       }
       _isDownloaodLoading = false;
       await OpenFile.open(filePathName);
       Navigator.of(Get.context!).pop();

     } else {
       _isDownloaodLoading = false;
       showCustomSnackBarWidget(getTranslated('product_download_failed', Get.context!), Get.context!, snackBarType: SnackBarType.warning);
       Navigator.of(Get.context!).pop();
     }
   } else {
     String? task;
     Directory downloadDirectory = Directory('/storage/emulated/0/Download');
     String filePathName = "${downloadDirectory.path}/$fileName";
     File savedFile = File(filePathName);
     bool fileExists = await savedFile.exists();


     if(fileExists) {
       showCustomSnackBarWidget(getTranslated('file_already_downloaded', Get.context!), Get.context!, snackBarType: SnackBarType.warning);
     } else{
       task  = await FlutterDownloader.enqueue(
         url: url,
         savedDir: downloadDirectory.path,
         fileName: fileName,
         showNotification: true,
         saveInPublicStorage: true,
         openFileFromNotification: true,
       );

       if(task != null) {
         showCustomSnackBarWidget(getTranslated('product_downloaded_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);

         if(!fileTypes.contains(getFileExtension(fileName))){
           await openFileManager(
             androidConfig: AndroidConfig(
               folderType: selectedFolderType,
             ),
             iosConfig: IosConfig(
               folderPath: subFolderPathCtrl.text.trim(),
             ),
           );
         }
       } else{
         showCustomSnackBarWidget(getTranslated('product_download_failed', Get.context!), Get.context!, snackBarType: SnackBarType.error);
       }
     }
     _isDownloaodLoading = false;
   }


    notifyListeners();
  }

  String getFileExtension(String fileName) {
    if (fileName.contains('.')) {
      return '.${fileName.split('.').last}';
    }
    return '';
  }

  Future<void> setOrderReviewExpanded(int index, bool status) async {

    if(status){
      final reviewController = Provider.of<ReviewController>(Get.context!, listen: false);
      reviewController.orderWiseReview = null;
    }

    if(_orderDetails != null){
      for(int i = 0; i< _orderDetails!.length;  i++){
        if(i == index){
          _orderDetails![i].isExpanded = status;
        } else{
          _orderDetails![i].isExpanded = false;
        }
      }
    }
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }


  bool isOfflineChecked = false;
  bool isCODChecked = false;
  bool isWalletChecked = false;

  int _paymentMethodIndex = -1;
  int get paymentMethodIndex => _paymentMethodIndex;


  void setOfflineChecked(String type, {bool notify = true}) {
    if(type == 'offline') {
      isOfflineChecked = !isOfflineChecked;
      isCODChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
      setOfflinePaymentMethodSelectedIndex(0, Provider.of<CheckoutController>(Get.context!, listen: false).offlinePaymentModel, notify: false);
    }else if(type == 'cod') {
      isCODChecked = !isCODChecked;
      isOfflineChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
      Provider.of<CheckoutController>(Get.context!, listen: false).setOfflineChecked('cod');
    }else if(type == 'wallet') {
      isWalletChecked = !isWalletChecked;
      isOfflineChecked = false;
      isCODChecked = false;
      _paymentMethodIndex = -1;
      Provider.of<CheckoutController>(Get.context!, listen: false).setOfflineChecked('wallet');
    }

    if(notify) {
      notifyListeners();
    }
  }


  String selectedDigitalPaymentMethodName = '';

  void setDigitalPaymentMethodName(int index, String name) {
    _paymentMethodIndex = index;
    selectedDigitalPaymentMethodName = name;
    isCODChecked = false;
    isWalletChecked = false;
    isOfflineChecked = false;
    notifyListeners();
  }

  List<TextEditingController> inputFieldControllerList = [];
  List <String?> keyList = [];
  int offlineMethodSelectedIndex = -1;
  int offlineMethodSelectedId = 0;
  String offlineMethodSelectedName = '';

  void setOfflinePaymentMethodSelectedIndex(int index, OfflinePaymentModel? offlinePaymentModel, {bool notify = true}) {
    keyList = [];
    inputFieldControllerList = [];
    offlineMethodSelectedIndex = index;
    if(offlinePaymentModel != null && offlinePaymentModel.offlineMethods!= null && offlinePaymentModel.offlineMethods!.isNotEmpty){
      offlineMethodSelectedId = offlinePaymentModel.offlineMethods![offlineMethodSelectedIndex].id!;
      offlineMethodSelectedName = offlinePaymentModel.offlineMethods![offlineMethodSelectedIndex].methodName!;
    }

    if(offlinePaymentModel!.offlineMethods != null && offlinePaymentModel.offlineMethods!.isNotEmpty && offlinePaymentModel.offlineMethods![index].methodInformations!.isNotEmpty){
      for (int i= 0; i< offlinePaymentModel.offlineMethods![index].methodInformations!.length; i++) {
        inputFieldControllerList.add(TextEditingController());
        keyList.add(offlinePaymentModel.offlineMethods![index].methodInformations![i].customerInput);
      }
    }
    if(notify) {
      notifyListeners();
    }
  }



  Future<ApiResponseModel> duePaymentByCod(int orderId, String? bringChangeAmount) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.duePaymentByCod(
        orderId, bringChangeAmount,
        Provider.of<SplashController>(Get.context!, listen: false).myCurrency?.code
    );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getOrderDetails(orderId.toString());
      getOrderFromOrderId(orderId.toString());
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponseModel> duePaymentByDigitalPayment(int orderId, String paymentMethod, String? orderDuePaymentNote) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.duePaymentByDigitalPayment(
        orderId,  paymentMethod, orderDuePaymentNote,
        Provider.of<SplashController>(Get.context!, listen: false).myCurrency?.code
    );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      final dynamic paymentData = ApiEnvelope.content(apiResponse.response!.data)['data'];
      RouterHelper.getDigitalPaymentScreenRoute(
        url: paymentData is Map ? (paymentData['redirect_link'] ?? '') : '',
        fromWallet: false,
        orderId: orderId.toString(),
        action: RouteAction.pushReplacement,
      );

      getOrderDetails(orderId.toString());
      getOrderFromOrderId(orderId.toString());
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }



  Future<ApiResponseModel> duePaymentByWallet(int orderId) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.duePaymentByWallet(orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getOrderDetails(orderId.toString());
      getOrderFromOrderId(orderId.toString());
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponseModel> duePaymentByOfflinePayment(int orderId, int? methodId, List<String?> typeKey, List<String> typeValue, String? orderDueNote) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderDetailsServiceInterface.duePaymentByOfflinePayment(orderId, methodId, typeKey, typeValue, orderDueNote);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getOrderDetails(orderId.toString());
      getOrderFromOrderId(orderId.toString());
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }





}
