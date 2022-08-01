////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис криптографии".
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Шифрует данные для заданного списка получателей.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке  - ИнформацияОбОшибке - описание ошибки выполнения.
//       * ЗашифрованныеДанные - ДвоичныеДанные, Строка, Массив - один или несколько файлов.
//                                                                Если данные переданы через временное хранилище,
//                                                                то и результат будет возвращен также.
//  
//   Данные - ДвоичныеДанные, Строка, Массив - один или несколько файлов, которые необходимо зашифровать.
//                                             Двоичные данные или адрес во временном хранилище файла данных,
//                                     		   который необходимо зашифровать.
//
//   Получатели - ДвоичныеДанные, Структура, ФиксированнаяСтруктура, Массив, ФиксированныйМассив - сертификаты получателей зашифрованного сообщения.
//                Либо ДвоичныеДанные файлов сертификатов или Структура с параметрами для поиска сертификатов в хранилище.
//     Структура - ключевые параметры сертификата, используемые для поиска.
//                 Отпечаток или пара СерийныйНомер и Издатель, или Сертификат с двоичными данными.
//       * Отпечаток     - ДвоичныеДанные, Строка - отпечаток сертификат.
//       * СерийныйНомер - ДвоичныеДанные, Строка - серийный номер сертификата.
//       * Издатель      - Структура, ФиксированнаяСтруктура, Строка - свойства издателя.
//       * Сертификат    - ДвоичныеДанные - файл сертификата.
//
//   ТипШифрования - Строка - тип шифрования. Поддерживается только CMS.
//
//   ПараметрыШифрования - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры шифрования.
//
Процедура Зашифровать(ОповещениеОЗавершении, Данные, Получатели, ТипШифрования = "CMS", ПараметрыШифрования = Неопределено) Экспорт
	
	СервисКриптографииСлужебныйКлиент.Зашифровать(ОповещениеОЗавершении, Данные, Получатели, ТипШифрования, ПараметрыШифрования);
	
КонецПроцедуры

// Шифрует блок данных для получателя.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке  - ИнформацияОбОшибке - описание ошибки выполнения.
//       * ЗашифрованныеДанные - ДвоичныеДанные, Строка, Массив - один или несколько файлов.
//                                                                Если данные переданы через временное хранилище,
//                                                                то и результат будет возвращен также.
//  
//   Данные - ДвоичныеДанные, Строка - Двоичные данные или адрес во временном хранилище файла данных,
//                                     		   который необходимо зашифровать.
//
//   Получатель - ДвоичныеДанные, Структура, ФиксированнаяСтруктура  - сертификат получателея зашифрованного сообщения.
//                Либо ДвоичныеДанные файлов сертификатов или Структура с параметрами для поиска сертификатов в хранилище.
//     Структура - ключевые параметры сертификата, используемые для поиска.
//                 Отпечаток или пара СерийныйНомер и Издатель, или Сертификат с двоичными данными.
//       * Отпечаток     - ДвоичныеДанные, Строка - отпечаток сертификат.
//       * СерийныйНомер - ДвоичныеДанные, Строка - серийный номер сертификата.
//       * Издатель      - Структура, ФиксированнаяСтруктура, Строка - свойства издателя.
//       * Сертификат    - ДвоичныеДанные - файл сертификата.
//
Процедура ЗашифроватьБлок(ОповещениеОЗавершении, Данные, Получатель) Экспорт
	
	СервисКриптографииСлужебныйКлиент.ЗашифроватьБлок(ОповещениеОЗавершении, Данные, Получатель);
	
КонецПроцедуры

// Выполняет расшифровку данных.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке   - ИнформацияОбОшибке - описание ошибки выполнения.
//       * РасшифрованныеДанные - ДвоичныеДанные, Строка - если данные переданы через временное хранилище,
//                                                        то и результат будет возвращен также.
//       * Получатели           - ФиксированныйМассив - сертификаты, на которые зашифрованы данные.
//
//   ЗашифрованныеДанные - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище файла данных,
//                                                  который необходимо расшифровать.
//
//   ТипШифрования - Строка - поддерживается только CMS.
//
//   ПараметрыШифрования - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры шифрования.
//
Процедура Расшифровать(ОповещениеОЗавершении, ЗашифрованныеДанные, ТипШифрования = "CMS", ПараметрыШифрования = Неопределено) Экспорт
	
	СервисКриптографииСлужебныйКлиент.Расшифровать(ОповещениеОЗавершении, ЗашифрованныеДанные, ТипШифрования, ПараметрыШифрования);
	
КонецПроцедуры

// Выполняет расшифровку блока данных.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено            - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке   - ИнформацияОбОшибке - описание ошибки выполнения.
//       * РасшифрованныеДанные - ДвоичныеДанные, Строка - если данные переданы через временное хранилище,
//                                                        то и результат будет возвращен также.
//       * Получатели           - ФиксированныйМассив - сертификаты, на которые зашифрованы данные.
//
//   ЗашифрованныеДанные - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище файла данных,
//                                                  который необходимо расшифровать.
//
//   Получатель - ДвоичныеДанные, Структура, ФиксированнаяСтруктура  - сертификат получателя зашифрованного сообщения.
//                Либо ДвоичныеДанные файлов сертификатов или Структура с параметрами для поиска сертификатов в хранилище.
//
//   КлючеваяИнформация - Структура, ФиксированнаяСтруктура - позволяет передать данные о ключах шифрования в запрос.
//       * ephemeral_key - ДвоичныеДанные, Строка в base64, эфемерный ключ
//       * session_key - ДвоичныеДанные, Строка в base64, сессионный ключ
//       * iv_data - ДвоичныеДанные, Строка в base64, данные вектора инициализации
//
//   ПараметрыШифрования - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры шифрования.
//       * ОчиститьДополняющиеБайты - Булево, флаг определяющий будут ли удалены заполняющие байты. По-умолчанию - удаляются
//
Процедура РасшифроватьБлок(ОповещениеОЗавершении, ЗашифрованныеДанные, Получатель, КлючеваяИнформация, ПараметрыШифрования = Неопределено) Экспорт
	
	СервисКриптографииСлужебныйКлиент.РасшифроватьБлок(ОповещениеОЗавершении, ЗашифрованныеДанные, Получатель, КлючеваяИнформация, ПараметрыШифрования);
	
КонецПроцедуры

// Выполняет подписание данных.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * Подпись        - ДвоичныеДанные, Строка, Массив - один или несколько файлов.
//                                                           Если данные переданы через временное хранилище,
//                                                           то и результат будет возвращен также.
//
//   Данные - ДвоичныеДанные, Строка, Массив - один или несколько файлов, которые необходимо подписать. 
//                                             Двоичные данные или адрес во временном хранилище файла данных,
//                                             который необходимо подписать.
//
//   Подписант - Структура, ФиксированнаяСтруктура, ДвоичныеДанные - сертификат для подписания.
//                Либо ДвоичныеДанные файлов сертификатов или Структура с параметрами для поиска сертификатов в хранилище.
//     Структура - ключевые параметры сертификата, используемые для поиска.
//                 Отпечаток или пара СерийныйНомер и Издатель, или Сертификат с двоичными данными.
//       * Отпечаток     - ДвоичныеДанные, Строка - отпечаток сертификат.
//       * СерийныйНомер - ДвоичныеДанные, Строка - серийный номер сертификата.
//       * Издатель      - Структура, ФиксированнаяСтруктура, Строка - свойства издателя.
//       * Сертификат    - ДвоичныеДанные - файл сертификата.
//
//   ТипПодписи - Строка - тип подписи. Поддерживаются только CMS или GOST3410.
//
//   ПараметрыПодписания - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры подписания.
//     * ОтсоединеннаяПодпись - Булево - поддерживается только CMS, если Истина, то будет сформирована отсоединенная подпись, иначе - присоединенная.
//                                       Истина - значение по умолчанию.
//
Процедура Подписать(ОповещениеОЗавершении, Данные, Подписант, ТипПодписи = "CMS", ПараметрыПодписания = Неопределено) Экспорт
	
	СервисКриптографииСлужебныйКлиент.Подписать(ОповещениеОЗавершении, Данные, Подписант, ТипПодписи, ПараметрыПодписания);
	
КонецПроцедуры

// Выполняет проверку подписи.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * ПодписьДействительна - Истина - результат проверки подписи.
//
//   Подпись - ДвоичныеДанные - подпись, которую необходимо проверить.
//
//   Данные - ДвоичныеДанные - исходные данные, необходимые для проверки подписи. Используется для проверки ОтсоединеннаяПодпись.
//
//   ТипПодписи - Строка - тип подписи. Поддерживаются только "CMS" или "GOST3410".
//
//   ПараметрыПодписания - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры подписания.
//     * ОтсоединеннаяПодпись - Булево - используется совместно с ТипПодписи = "CMS", если Истина, то подпись будет проверяться с использованием Данные.
//                                       Истина - значение по умолчанию.
//     * Сертификат - ДвоичныеДанные - файл сертификата, обязательно используется совместно с ТипПодписи = "GOST3410".
//
Процедура ПроверитьПодпись(ОповещениеОЗавершении, Подпись, Данные = Неопределено, ТипПодписи = "CMS", ПараметрыПодписания = Неопределено) Экспорт
	
	СервисКриптографииСлужебныйКлиент.ПроверитьПодпись(ОповещениеОЗавершении, Подпись, Данные, ТипПодписи, ПараметрыПодписания);
	
КонецПроцедуры

// Выполняет проверку сертификата.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * Действителен - Булево - сертификат соответствует требованиям проверки.
//  
//   Сертификат - ДвоичныеДанные - файл сертификата.
//
Процедура ПроверитьСертификат(ОповещениеОЗавершении, Сертификат) Экспорт
	
	СервисКриптографииСлужебныйКлиент.ПроверитьСертификат(ОповещениеОЗавершении, Сертификат);
	
КонецПроцедуры

// Получает основные свойства переданного сертификата.
// 
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * Сертификат - ФиксированнаяСтруктура - свойства сертификата.
//           ** Версия - Строка - версия сертификата.
//           ** ДатаНачала - Дата - дата начала действия сертификата (UTC).
//           ** ДатаОкончания - Дата - дата окончания действия сертификата (UTC).
//                *** Издатель - ФиксированнаяСтруктура - информация об издателе сертификата:
//                *** CN - commonName; 
//                *** O - organizationName; 
//                *** OU - organizationUnitName; 
//                *** C - countryName; 
//                *** ST - stateOrProvinceName; 
//                *** L - localityName; 
//                *** E - emailAddress; 
//                *** SN - surname; 
//                *** GN - givenName; 
//                *** T - title;
//                *** STREET - streetAddress;
//                *** OGRN - ОГРН;
//                *** OGRNIP - ОГРНИП;
//                *** INN - ИНН;
//                *** SNILS - СНИЛС;
//                   ...
//           ** ИспользоватьДляПодписи - Булево - указывает, можно ли использовать данный сертификат для подписи.
//           ** ИспользоватьДляШифрования - Булево - указывает, можно ли использовать данный сертификат для шифрования.
//           ** ОткрытыйКлюч - ДвоичныеДанные - содержит данные открытого ключа.
//           ** Отпечаток - ДвоичныеДанные - содержит данные отпечатка. Вычисляется динамически, по алгоритму SHA-1.
//           ** РасширенныеСвойства - ФиксированнаяСтруктура -  расширенные свойства сертификата:
//                *** EKU - ФиксированныйМассив - Enhanced Key Usage.
//           ** СерийныйНомер - ДвоичныеДанные - серийный номер сертификата.
//           ** Субъект - ФиксированнаяСтруктура - информацию о субъекте сертификата. Состав см. Издатель.
//           ** Сертификат - ДвоичныеДанные - файл сертификата в кодировке DER.
//           ** Идентификатор - Строка - вычисляется по ключевым свойствам Издателя и серийному номеру по алгоритму SHA1.
//                                  Используется для идентификации сертификата в сервисе криптографии.
//
//   Сертификат - ДвоичныеДанные - сертификат, свойства которого необходимо получить.
//
Процедура ПолучитьСвойстваСертификата(ОповещениеОЗавершении, Сертификат) Экспорт
	
	СервисКриптографииСлужебныйКлиент.ПолучитьСвойстваСертификата(ОповещениеОЗавершении, Сертификат);
	
КонецПроцедуры

// Извлекает массив сертификатов из данных подписи.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * Сертификаты - Массив - массив объектов ФиксированнаяСтруктура - описаний сертификатов (см. ПолучитьСвойстваСертификата).
//  
//   Подпись - ДвоичныеДанные - файл подписи.
//            Строка - адрес во временном хранилище.
//
Процедура ПолучитьСертификатыИзПодписи(ОповещениеОЗавершении, Подпись) Экспорт
	
	СервисКриптографииСлужебныйКлиент.ПолучитьСертификатыИзПодписи(ОповещениеОЗавершении, Подпись);
	
КонецПроцедуры

// Выполняет расчет хеш-суммы по переданным данным.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - Структура - результат выполнения процедуры.
//       * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ИнформацияОбОшибке.
//       * ИнформацияОбОшибке - ИнформацияОбОшибке - описание ошибки выполнения.
//       * Хеш  - ДвоичныеДанные - значение хеш-суммы.
//
//   Данные - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище файла данных,
//                                     от которых необходимо посчитать хеш-сумму.
//   АлгоритмХеширования - Строка - константа из списка "GOST R 34.11-94", "GOST R 34.11-2012 256", "GOST R 34.11-2012 512".
//
//   ПараметрыХеширования - Структура, ФиксированнаяСтруктура - позволяет указать дополнительные параметры хеширования.
//     * ИнвертироватьПолубайты - Булево - управляет инвертированием полубайт в значении хеш-суммы. Применяется только для "GOST R 34.11-94"
//                                Например, прямой порядок - 62 FB, обратный - 26 BF.
//                                Истина - значение по умолчанию.
//
Процедура ХешированиеДанных(ОповещениеОЗавершении, Данные, АлгоритмХеширования = "GOST R 34.11-94", ПараметрыХеширования = Неопределено) Экспорт

	СервисКриптографииСлужебныйКлиент.ХешированиеДанных(ОповещениеОЗавершении, Данные, АлгоритмХеширования, ПараметрыХеширования);
	
КонецПроцедуры

#КонецОбласти
