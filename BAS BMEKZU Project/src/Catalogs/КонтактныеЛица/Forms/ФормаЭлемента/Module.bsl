#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыРазмещенияКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ПараметрыРазмещенияКонтактнойИнформации.ИмяЭлементаДляРазмещения = "ГруппаКонтактнаяИнформация";
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ПараметрыРазмещенияКонтактнойИнформации);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	текФамилия  = Объект.Фамилия;
    текИмя      = Объект.Имя;
    текОтчество = Объект.Отчество;
	ПриИзмененииВидаКонтактногоЛица();
	ВидимостьДопонительнойИнформации(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	Если Объект.ВидКонтактногоЛица = ПредопределенноеЗначение("Перечисление.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента")
		И Параметры.Ключ.Пустая() Тогда
		Элементы.ВидКонтактногоЛица.Доступность    = Ложь;
		Элементы.ВидКонтактногоЛица.ТолькоПросмотр = Истина;
	КонецЕсли;

	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ТипЗнч(Объект.ОбъектВладелец) = Тип("СправочникСсылка.Контрагенты") Тогда
	
		ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.ОбъектВладелец);
		Оповестить("ИзмененоКонтактноеЛицоКонтарагента", ПараметрОповещения);	
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидКонтактногоЛицаПриИзменении(Элемент)

 	ПриИзмененииВидаКонтактногоЛица();
	ВидимостьДопонительнойИнформации(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента Фамилия.
//
&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	ПозицииПробелов = ОпределитьПозицииПробелов();

	Если ПозицииПробелов[0] > 0 Тогда

		ФамилияИзНаименования = Сред(Объект.Наименование, 1, (ПозицииПробелов[0] - 1));

		Если ФамилияИзНаименования <> текФамилия И НЕ ПустаяСтрока(ФамилияИзНаименования) Тогда
			
			текФамилия = СокрЛП(Объект.Фамилия);
			Возврат;

		КонецЕсли;

		Объект.Наименование = СокрЛП(Объект.Фамилия) + Сред(Объект.Наименование, ПозицииПробелов[0]);

	Иначе

		Если ПустаяСтрока(Объект.Наименование) Тогда

			Объект.Наименование = СокрЛП(Объект.Фамилия);

		Иначе

			Если СокрЛП(Объект.Наименование) = текФамилия Тогда

				Объект.Наименование = СокрЛП(Объект.Фамилия);

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	текФамилия = СокрЛП(Объект.Фамилия);

КонецПроцедуры

// Обработчик события ПриИзменении элемента Имя.
//
&НаКлиенте
Процедура ИмяПриИзменении(Элемент)

	ПозицииПробелов = ОпределитьПозицииПробелов();

	Если ПозицииПробелов[0] > 0 И ПозицииПробелов[1] > 0 Тогда

		ИмяИзНаименования = Сред(Объект.Наименование, (ПозицииПробелов[0] + 1), (ПозицииПробелов[1] - ПозицииПробелов[0] - 1));

		Если ИмяИзНаименования <> текИмя И НЕ ПустаяСтрока(ИмяИзНаименования) Тогда

			текИмя = СокрЛП(Объект.Имя);
			Возврат;

		КонецЕсли;

		Объект.Наименование = Сред(Объект.Наименование, 1, ПозицииПробелов[0]) + СокрЛП(Объект.Имя) + Сред(Объект.Наименование, ПозицииПробелов[1]);

	ИначеЕсли ПозицииПробелов[0] > 0 Тогда

		ИмяИзНаименования = Сред(Объект.Наименование, (ПозицииПробелов[0] + 1));

		Если ИмяИзНаименования <> текИмя И НЕ ПустаяСтрока(ИмяИзНаименования) Тогда

			текИмя = СокрЛП(Объект.Имя);
			Возврат;

		КонецЕсли; 

		Объект.Наименование = Сред(Объект.Наименование, 1, ПозицииПробелов[0]) + СокрЛП(Объект.Имя);

	Иначе

		Если НЕ ПустаяСтрока(Объект.Наименование) Тогда

			Объект.Наименование = Объект.Наименование + " " + СокрЛП(Объект.Имя);

		Иначе

			Объект.Наименование = " " + СокрЛП(Объект.Имя);

		КонецЕсли; 

	КонецЕсли;

	текИмя = СокрЛП(Объект.Имя);

КонецПроцедуры

// Обработчик события ПриИзменении элемента Отчество.
//
&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)

	ПозицииПробелов = ОпределитьПозицииПробелов();

	Если ПозицииПробелов[1] > 0 Тогда

		ОтчествоИзНаименования = Сред(Объект.Наименование, (ПозицииПробелов[1] + 1));

		Если ОтчествоИзНаименования <> текОтчество И НЕ ПустаяСтрока(ОтчествоИзНаименования) Тогда

			текОтчество = СокрЛП(Объект.Отчество);
			Возврат;

		КонецЕсли;

		Объект.Наименование = Сред(Объект.Наименование, 1, ПозицииПробелов[1]) + СокрЛП(Объект.Отчество);

	Иначе

		Если НЕ ПустаяСтрока(Объект.Наименование) Тогда

			Объект.Наименование = Объект.Наименование + " " + СокрЛП(Объект.Отчество);

		Иначе

			Объект.Наименование = "  " + СокрЛП(Объект.Отчество);

		КонецЕсли;

	КонецЕсли;

	текОтчество = СокрЛП(Объект.Отчество);

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокВыбора = Новый СписокЗначений;

	Если НЕ ПустаяСтрока(Объект.Фамилия) Тогда
		СписокВыбора.Добавить(СокрЛП(Объект.Фамилия));
	КонецЕсли;

	Если НЕ ПустаяСтрока(Объект.Фамилия) И НЕ ПустаяСтрока(Объект.Имя) Тогда
		СписокВыбора.Добавить((СокрЛП(Объект.Фамилия) + " " + СокрЛП(Объект.Имя)));
		СписокВыбора.Добавить((СокрЛП(Объект.Фамилия) + " " + СокрЛП(Сред(Объект.Имя,1,1)) + "."));
	КонецЕсли;

	Если НЕ ПустаяСтрока(Объект.Фамилия) И НЕ ПустаяСтрока(Объект.Имя) И НЕ ПустаяСтрока(Объект.Отчество) Тогда
		СписокВыбора.Добавить((СокрЛП(Объект.Фамилия) + " " + СокрЛП(Объект.Имя) + " " + СокрЛП(Объект.Отчество)));
		СписокВыбора.Добавить((СокрЛП(Объект.Фамилия) + " " + СокрЛП(Сред(Объект.Имя,1,1)) + "." + СокрЛП(Сред(Объект.Отчество,1,1)) + "."));
	КонецЕсли;

	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, СписокВыбора, Элементы.Наименование);

КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Наименование = Результат.Значение;
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииВидаКонтактногоЛица()

	Если НЕ ЗначениеЗаполнено(Объект.ВидКонтактногоЛица) Тогда
		Объект.ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ЛичныйКонтакт;
	КонецЕсли;

	Если Объект.ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента Тогда

		Если ТипЗнч(Объект.ОбъектВладелец) <> Тип("СправочникСсылка.Контрагенты") Тогда
			Объект.ОбъектВладелец = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
		
	ИначеЕсли Объект.ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ЛичныйКонтакт Тогда

		Если Объект.ОбъектВладелец <> Пользователи.ТекущийПользователь() Тогда
			Объект.ОбъектВладелец = Пользователи.ТекущийПользователь();
		КонецЕсли;
		
	Иначе

		Если ТипЗнч(Объект.ОбъектВладелец) <> Тип("СправочникСсылка.Пользователи") Тогда
			Объект.ОбъектВладелец = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект 	 = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.ВидКонтактногоЛица = ПредопределенноеЗначение("Перечисление.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента") Тогда

		Элементы.ОбъектВладелец.Заголовок 	   = "Контрагент";
		Элементы.ОбъектВладелец.Доступность	   = Истина;
		Элементы.ОбъектВладелец.ТолькоПросмотр = Ложь;
			
	ИначеЕсли Объект.ВидКонтактногоЛица = ПредопределенноеЗначение("Перечисление.ВидыКонтактныхЛиц.ЛичныйКонтакт") Тогда	

		Элементы.ОбъектВладелец.Заголовок 	   = "Ответственный";
		Элементы.ОбъектВладелец.Доступность	   = Ложь;
		Элементы.ОбъектВладелец.ТолькоПросмотр = Истина
		
	Иначе
		
		Элементы.ОбъектВладелец.Заголовок 	   = "Ответственный";
		Элементы.ОбъектВладелец.Доступность	   = Истина;
		Элементы.ОбъектВладелец.ТолькоПросмотр = Ложь;
    		
	КонецЕсли;
		
КонецПроцедуры	

&НаКлиенте
Функция ОпределитьПозицииПробелов()

	Пробелы = Новый Массив;

	Для а = 1 По 2 Цикл

		Пробелы.Добавить(0);

	КонецЦикла; 

	КолПробелов = 0;

	Для а = 1 По СтрДлина(Объект.Наименование) Цикл

		Если Сред(Объект.Наименование, а, 1) = " " Тогда

			Пробелы[КолПробелов] = а;
			КолПробелов = КолПробелов + 1;

		КонецЕсли;

		Если КолПробелов = 2 Тогда

			Прервать;

		КонецЕсли;

	КонецЦикла;

	Возврат Пробелы;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДопонительнойИнформации(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.ВидКонтактногоЛица = ПредопределенноеЗначение("Перечисление.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента") Тогда
		Элементы.ГруппаРеквизитыКонтрагента.Видимость = Истина;
	Иначе
		Элементы.ГруппаРеквизитыКонтрагента.Видимость = Ложь;
	КонецЕсли; 

КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
