# MoySkladSDK

`MoySkladSDK` - клиент к REST API сервиса МойСклад. Описание REST API можно найти по этой [ссылке](https://online.moysklad.ru/api/remap/1.1/doc/index.html).

## Установка

SDK использует Alamofire (=> 4.4.0) и RxSwift (=> 3.2.0), поэтому эти две библиотеки так же должны быть добавлены в приложение.

### Установка через CocoaPods
Добавить в Podfile
```
pod "MoySkladSDK"
```

### Установка через Carthage
Добавить следующую строчку в cartfile
```
git "https://github.com/MoySklad/moysklad-ios-sdk.git" ~> 1.0
```
и выполнить
```
carthage update
```

## Примеры использования

### Загрузка Ассортимента:
```swift
DataManager.assortment(auth: Auth(username: "user_name", password: "password"),
                               offset: MSOffset(size: 0, limit: 20, offset: 10),
                               expanders: [Expander.create(.product, children: [Expander.init(.salePrices)]),
                                           Expander(.owner)],
                               scope: AssortmentScope.variant)
            .subscribe(onNext: { assortment in
                // do something
            })
            .disposed(by: disposeBag)
```
Данный запрос загрузит максимум 20 сущностей типа Ассортимент, при этом первые 10 будут пропущены. Так же в результат запроса будут включены связанные сущности находящиеся в свойствах product product.salePrices и owner.

### Загрузка документов
```swift
DataManager.load(docType: MSCustomerOrder.self,
                         auth: Auth(username: "user_name", password: "password"),
                         offset: MSOffset(size: 0, limit: 10, offset: 0))
                    .subscribe(onNext: { documents in
                        // do something
                    })
                    .disposed(by: disposeBag)
```
Данный запрос загрузит первые десять документов типа CustomerOrder.

### Загрузка информации по продажам
```swift
DataManager.dashboardMonth(auth: Auth(username: "user_name", password: "password"))
    .subscribe(onNext: { dashboard in
        // do something
    })
    .disposed(by: disposeBag)
```
Данный запрос загрузит краткую информацию по продажам за последний месяц.
