////////////////////////////////////////////////////////////////////////////////
// Подсистема "Запрет редактирования реквизитов объектов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет, что для объекта метаданных предусмотрен запрет редактирования реквизитов.
//
// Параметры:
//  ПолноеИмя - Строка - полное имя объекта метаданных.
//
Функция ЗапретРедактированияПредусмотрен(ПолноеИмя) Экспорт
	
	Объекты = Новый Соответствие;
	ИнтеграцияПодсистемБСП.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	
	Возврат Объекты[ПолноеИмя] <> Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Настраивает форму объекта для работы подсистемы:
// - добавляет реквизит ПараметрыЗапретаРедактированияРеквизитов для хранения внутренних данных
// - добавляет команду и кнопку РазрешитьРедактированиеРеквизитовОбъекта (если есть права).
//
Процедура ПодготовитьФорму(Форма, Ссылка, ГруппаДляКнопкиЗапрета, ЗаголовокКнопкиЗапрета) Экспорт
	
	ОписаниеТиповСтрока100 = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100));
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	ОписаниеТиповМассив = Новый ОписаниеТипов("СписокЗначений");
	
	РеквизитыФормы = Новый Соответствие;
	Для каждого РеквизитФормы Из Форма.ПолучитьРеквизиты() Цикл
		РеквизитыФормы.Вставить(РеквизитФормы.Имя, РеквизитФормы.Заголовок);
	КонецЦикла;
	
	// Добавление реквизитов на форму.
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПараметрыЗапретаРедактированияРеквизитов", Новый ОписаниеТипов("ТаблицаЗначений")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИмяРеквизита",            ОписаниеТиповСтрока100, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Представление",           ОписаниеТиповСтрока100, "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РедактированиеРазрешено", ОписаниеТиповБулево,    "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("БлокируемыеЭлементы",     ОписаниеТиповМассив,    "ПараметрыЗапретаРедактированияРеквизитов"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПравоРедактирования",     ОписаниеТиповБулево,    "ПараметрыЗапретаРедактированияРеквизитов"));
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	БлокируемыеРеквизиты = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка).ПолучитьБлокируемыеРеквизитыОбъекта();
	ВсеРеквизитыБезПраваРедактирования = Истина;
	
	Для Каждого БлокируемыйРеквизит Из БлокируемыеРеквизиты Цикл
		
		ОписаниеРеквизита = Форма.ПараметрыЗапретаРедактированияРеквизитов.Добавить();
		
		ИнформацияОБР = СтрРазделить(БлокируемыйРеквизит, ";", Ложь);
		ОписаниеРеквизита.ИмяРеквизита = ИнформацияОБР[0];
		
		Если ИнформацияОБР.Количество() > 1 Тогда
			БлокируемыеЭлементы = СтрРазделить(ИнформацияОБР[1], ",", Ложь);
			Для Каждого БлокируемыйЭлемент Из БлокируемыеЭлементы Цикл
				ОписаниеРеквизита.БлокируемыеЭлементы.Добавить(СокрЛП(БлокируемыйЭлемент));
			КонецЦикла;
		КонецЕсли;
		
		МетаданныеОбъекта = Ссылка.Метаданные();
		ЭтоПланСчетов = ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта);
		ЕстьСтандартныеТабличныеЧасти = ЭтоПланСчетов Или ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъекта);
		
		МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.Реквизиты.Найти(ОписаниеРеквизита.ИмяРеквизита);
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено И ЭтоПланСчетов Тогда
			МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.ПризнакиУчета.Найти(ОписаниеРеквизита.ИмяРеквизита);
		КонецЕсли;
		СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Ложь;
		
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
			МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.ТабличныеЧасти.Найти(ОписаниеРеквизита.ИмяРеквизита);
			
			Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено
			   И ЕстьСтандартныеТабличныеЧасти
			   И ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеТабличныеЧасти, ОписаниеРеквизита.ИмяРеквизита) Тогда
					МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.СтандартныеТабличныеЧасти[ОписаниеРеквизита.ИмяРеквизита];
					СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Истина;
			КонецЕсли;
			Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ОписаниеРеквизита.ИмяРеквизита) Тогда
					МетаданныеРеквизитаИлиТабличнойЧасти = МетаданныеОбъекта.СтандартныеРеквизиты[ОписаниеРеквизита.ИмяРеквизита];
					СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если МетаданныеРеквизитаИлиТабличнойЧасти = Неопределено Тогда
			ОписаниеРеквизита.Представление = РеквизитыФормы[ОписаниеРеквизита.ИмяРеквизита];
			
			ОписаниеРеквизита.ПравоРедактирования = Истина;
			ВсеРеквизитыБезПраваРедактирования = Ложь;
		Иначе
			ОписаниеРеквизита.Представление = МетаданныеРеквизитаИлиТабличнойЧасти.Представление();
			
			Если СтандартныйРеквизитИлиСтандартнаяТабличнаяЧасть Тогда
				ПравоРедактирования = ПравоДоступа("Редактирование", МетаданныеОбъекта, , МетаданныеРеквизитаИлиТабличнойЧасти.Имя);
			Иначе
				ПравоРедактирования = ПравоДоступа("Редактирование", МетаданныеРеквизитаИлиТабличнойЧасти);
			КонецЕсли;
			Если ПравоРедактирования Тогда
				ОписаниеРеквизита.ПравоРедактирования = Истина;
				ВсеРеквизитыБезПраваРедактирования = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьСвязанныеЭлементы(Форма);
	
	// Добавление команды и кнопки, если есть права.
	Если Пользователи.РолиДоступны("РедактированиеРеквизитовОбъектов")
	   И ПравоДоступа("Редактирование", Ссылка.Метаданные())
	   И НЕ ВсеРеквизитыБезПраваРедактирования Тогда
		
		// Добавление команды
		Команда = Форма.Команды.Добавить("РазрешитьРедактированиеРеквизитовОбъекта");
		Команда.Заголовок = ?(ПустаяСтрока(ЗаголовокКнопкиЗапрета), НСтр("ru='Разрешить редактирование реквизитов';uk='Дозволити редагування реквізитів'"), ЗаголовокКнопкиЗапрета);
		Команда.Действие = "Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта";
		Команда.Картинка = БиблиотекаКартинок.РазрешитьРедактированиеРеквизитовОбъекта;
		Команда.ИзменяетСохраняемыеДанные = Истина;
		
		// Добавление кнопки
		РодительскаяГруппа = ?(ГруппаДляКнопкиЗапрета <> Неопределено, ГруппаДляКнопкиЗапрета, Форма.КоманднаяПанель);
		Кнопка = Форма.Элементы.Добавить("РазрешитьРедактированиеРеквизитовОбъекта", Тип("КнопкаФормы"), РодительскаяГруппа);
		Кнопка.ТолькоВоВсехДействиях = Истина;
		Кнопка.ИмяКоманды = "РазрешитьРедактированиеРеквизитовОбъекта";
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для процедуры ПодготовитьФорму.
// Дополняет массив блокируемых элементов формы связанными элементами.
Процедура ЗаполнитьСвязанныеЭлементы(Форма)
	
	Отбор = Новый Структура("ИмяРеквизита", Неопределено);
	
	Для Каждого ЭлементФормы Из Форма.Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы")
		   И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
		 Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
		
			РазложенныйПутьКДанным = СтрРазделить(ЭлементФормы.ПутьКДанным, ".", Ложь);
			
			Если РазложенныйПутьКДанным.Количество() = 2 Тогда
				Отбор.ИмяРеквизита = РазложенныйПутьКДанным[1];
				Строки = Форма.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(Отбор);
				Если Строки.Количество() > 0 Тогда
					Строки[0].БлокируемыеЭлементы.Добавить(ЭлементФормы.Имя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
