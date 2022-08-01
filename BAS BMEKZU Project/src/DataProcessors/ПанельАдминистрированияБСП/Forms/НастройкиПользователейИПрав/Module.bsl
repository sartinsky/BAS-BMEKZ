#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ОбщиеНастройкиВходаИспользуются() Тогда
		Элементы.ГруппаНастройкиВходаПользователей.Видимость = Ложь;
		Элементы.ГруппаСписокВнешнихПользователейОтступ.Видимость = Ложь;
		Элементы.ГруппаНастройкиВходаВнешнихПользователей.Видимость = Ложь;
		Элементы.ГруппаВнешниеПользователи.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто()
	 Или Не ПользователиСлужебный.ВнешниеПользователиВнедрены() Тогда
		
		Элементы.ГруппаВнешниеПользователи.Видимость = Ложь;
		Элементы.ОписаниеРаздела.Заголовок =
			НСтр("ru='Администрирование пользователей, настройка групп доступа, управление пользовательскими настройками.';uk='Адміністрування користувачів, настройка груп доступу, управління користувацькими настройками.'");
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.ИспользоватьГруппыПользователей.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		УпрощенныйИнтерфейс = МодульУправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
		Элементы.ОткрытьГруппыДоступа.Видимость            = НЕ УпрощенныйИнтерфейс;
		Элементы.ИспользоватьГруппыПользователей.Видимость = НЕ УпрощенныйИнтерфейс;
		Элементы.ОбновлениеДоступаНаУровнеЗаписей.Видимость =
			МодульУправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина);
		
		Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
			Элементы.ОграничиватьДоступНаУровнеЗаписей.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаГруппыДоступа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		Элементы.ГруппаДатыЗапретаИзменения.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.НастройкиПользователейИПравПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "ИспользоватьАнкетирование" 
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Анкетирование") Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	ИначеЕсли Источник = "ИспользоватьСкрытиеПерсональныхДанныхСубъектов" Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьГруппыПользователейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзменении(Элемент)
	
	Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		
		ТекстВопроса =
			НСтр("ru='Включить ограничение доступа на уровне записей?
                       |
                       |Потребуется заполнение данных, которое будет выполняться частями
                       |регламентным заданием ""Заполнение данных для ограничения доступа""
                       |(ход выполнения в журнале регистрации).
                       |
                       |Выполнение может сильно замедлить работу программы и выполняться
                       |от нескольких секунд до многих часов (в зависимости от объема данных).'
                       |;uk='Включити обмеження доступу на рівні записів?
                       |
                       |Потрібно заповнення даних, яке буде виконуватися частинами
                       |регламентним завданням ""Заповнення даних для обмеження доступу""
                       |(хід виконання в журналі реєстрації).
                       |
                       |Виконання може сильно уповільнити роботу програми і виконуватися
                       |від декількох секунд до багатьох годин (в залежності від обсягу даних).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение",
				ЭтотОбъект, Элемент),
			ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьВнешнихПользователей Тогда
		
		ТекстВопроса =
			НСтр("ru='Разрешить доступ внешним пользователям?
                       |
                       |При входе в программу список выбора пользователей станет пустым
                       |(реквизит ""Показывать в списке выбора"" в карточках всех
                       | пользователей будет очищен и скрыт).'
                       |;uk='Дозволити доступ зовнішнім користувачам?
                       |
                       |При вході в програму список вибору користувачів стане порожнім
                       |(реквізит ""Показувати в списку вибору"" в картках усіх
                       |користувачів буде очищено і прихований).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ТекстВопроса =
			НСтр("ru='Запретить доступ внешним пользователям?
                       |
                       |Реквизит ""Вход в программу разрешен"" будет
                       |очищен в карточках всех внешних пользователей.'
                       |;uk='Заборонити доступ зовнішнім користувачам?
                       |
                       |Реквізит ""Вхід в програму дозволено"" буде
                       |очищений в картках усіх зовнішніх користувачів.'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправочникВнешниеПользователи(Команда)
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаВнешнихПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьНастройкиВнешнихПользователей", Истина);
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДоступаНаУровнеЗаписей(Команда)
	
	ОткрытьФорму("РегистрСведений" + "." + "ОбновлениеКлючейДоступаКДанным" + "."
		+ "Форма" + "." + "ОбновлениеДоступаНаУровнеЗаписей");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

&НаКлиенте
Процедура ИНАГРО_ПраваПользователейЭлеватор(Команда) // ИНАГРО	
	
	ОткрытьФорму("РегистрСведений.ИНАГРО_ПраваПользователейЭлеватор.Форма.ФормаСписка", , ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	МассивИменКонстант = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Для Каждого КонстантаИмя Из МассивИменКонстант Цикл
		Если КонстантаИмя <> "" Тогда
			Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ОграничиватьДоступНаУровнеЗаписей = Ложь;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ИспользоватьВнешнихПользователей = Не НаборКонстант.ИспользоватьВнешнихПользователей;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	МассивИменКонстант = Новый Массив;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		
		КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
		МассивИменКонстант.Добавить(КонстантаИмя);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат МассивИменКонстант;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		ТекущееЗначение  = КонстантаМенеджер.Получить();
		
		Если ТекущееЗначение <> КонстантаЗначение Тогда
			Попытка
				КонстантаМенеджер.Установить(КонстантаЗначение);
			Исключение
				НаборКонстант[КонстантаИмя] = ТекущееЗначение;
				ВызватьИсключение;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнешнихПользователей"
	 Или РеквизитПутьКДанным = "" Тогда
		
		ИспользоватьВнешнихПользователей = НаборКонстант.ИспользоватьВнешнихПользователей;
		
		Элементы.ОткрытьВнешниеПользователи.Доступность         = ИспользоватьВнешнихПользователей;
		Элементы.НастройкиВходаВнешнихПользователей.Доступность = ИспользоватьВнешнихПользователей;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения")
		И (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаИзменения"
		Или РеквизитПутьКДанным = "") Тогда
		
		Элементы.ГруппаДатыЗапретаИзмененияНастройка.Доступность =
			НаборКонстант.ИспользоватьДатыЗапретаИзменения;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом")
		И (РеквизитПутьКДанным = "НаборКонстант.ОграничиватьДоступНаУровнеЗаписей"
		Или РеквизитПутьКДанным = "") Тогда
		
		Элементы.ОбновлениеДоступаНаУровнеЗаписей.Доступность =
			НаборКонстант.ОграничиватьДоступНаУровнеЗаписей;
	КонецЕсли;
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБЭМКЗУ() Тогда // ИНАГРО
		Элементы.ГруппаИНАГРО_ПраваПользоватлейЭлеватор.Видимость = Истина;
	Иначе
		Элементы.ГруппаИНАГРО_ПраваПользоватлейЭлеватор.Видимость = Ложь;   
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти
