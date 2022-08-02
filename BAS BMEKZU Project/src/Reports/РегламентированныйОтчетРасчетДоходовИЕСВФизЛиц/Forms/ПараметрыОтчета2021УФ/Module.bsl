// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мПараметры = Новый Структура();
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	НеВключатьЧПников 		= Параметры.НеВключатьЧПников;
	МесяцПриложения 		= Параметры.МесяцПриложения;
	ВыплатыЗПНеРегулярны 	= Параметры.ВыплатыЗПНеРегулярны;
	Подразделение 			= Параметры.Подразделение;
	СортироватьПоИНН		= Параметры.СортироватьПоИНН;
	ОбособленноеПодразделение = Параметры.ОбособленноеПодразделение;
	ОпцияКадровыйПереводДвумяСтроками = Параметры.ОпцияКадровыйПереводДвумяСтроками;
	ЧислоВыплатыЗП = Параметры.ЧислоВыплатыЗП;
	НазначениеПенсии = Параметры.НазначениеПенсии;
	НазначениеСоцВыплат = Параметры.НазначениеСоцВыплат;
	//Сотрудники  = Параметры.Сотрудники;
	ОпцияПриемУвольнениеОтдельнымиСтроками = Параметры.ОпцияПриемУвольнениеОтдельнымиСтроками;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("ОбособленноеПодразделение", ОбособленноеПодразделение);
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная(); 
	СтруктураПараметров.Вставить("ЗарплатаКадрыРасширенная", ЗарплатаКадрыРасширенная);
	Если ЗарплатаКадрыРасширенная Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;
	СтруктураПараметров.Вставить("НазначениеПенсии", НазначениеПенсии);
	СтруктураПараметров.Вставить("НазначениеСоцВыплат", НазначениеСоцВыплат);
	СтруктураПараметров.Вставить("ОпцияПриемУвольнениеОтдельнымиСтроками", ОпцияПриемУвольнениеОтдельнымиСтроками);

	Если НЕ Параметры.Сотрудники = Неопределено Тогда
		Для каждого Эл Из Параметры.Сотрудники Цикл
			Строка = Сотрудники.Добавить();
			Строка.Сотрудник = Эл; 
		КонецЦикла;
	КонецЕсли;
	
	Если НазначениеПенсии Или НазначениеСоцВыплат Тогда
		СтруктураПараметров.Элементы.СписокСотрудников.Видимость = Истина;
		СтруктураПараметров.Элементы.СотрудникиЗаполнитьСписокПоБольничнымФСС.Видимость = СтруктураПараметров.НазначениеСоцВыплат И ЗарплатаКадрыРасширенная;
	Иначе
		СтруктураПараметров.Элементы.СписокСотрудников.Видимость = Ложь;
		Сотрудники.Очистить();	
	КонецЕсли;
	
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	
	УправлениеЭУ(СтруктураПараметров);
	
	УстановитьВидимостьПодразделения(СтруктураПараметров);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеЭУ(СтруктураПараметров)
	
	СтруктураПараметров.Элементы.ПараметрыВыплаты.Видимость  = НЕ СтруктураПараметров.ВыплатыЗПНеРегулярны;
	Если Не СтруктураПараметров.ЗарплатаКадрыРасширенная Тогда
		СтруктураПараметров.Элементы.НеВключатьЧПников.Видимость = ЗначениеЗаполнено(СтруктураПараметров.Подразделение);
	Иначе
		Если СтруктураПараметров.ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ Тогда 
			СтруктураПараметров.Элементы.НеВключатьЧПников.Видимость = ЗначениеЗаполнено(СтруктураПараметров.ОбособленноеПодразделение);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры // УправлениеЭУ()

&НаСервере 
Процедура УстановитьВидимостьПодразделения(СтруктураПараметров)
	
	Если СтруктураПараметров.ЗарплатаКадрыРасширенная Тогда
		Элементы.Подразделение.Видимость = Ложь;
		Если СтруктураПараметров.ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ Тогда 
			Элементы.ОбособленноеПодразделение.Видимость = Истина
		Иначе
			Элементы.ОбособленноеПодразделение.Видимость = Ложь			
		КонецЕсли	
	Иначе
		Элементы.Подразделение.Видимость = Истина;
		Элементы.ОбособленноеПодразделение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимостьПодразделения()

&НаСервере
Функция ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ()
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ");
	
КонецФункции
// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы <> Неопределено Тогда 
		
		Если ЗавершениеРаботы И Модифицированность Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
			
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриЗакрытии()
	
	ВладелецФормы.СтруктураРеквизитовФормы.ЧислоВыплатыЗП 			= ЧислоВыплатыЗП;
	ВладелецФормы.СтруктураРеквизитовФормы.Подразделение 			= Подразделение;
	ВладелецФормы.СтруктураРеквизитовФормы.ОбособленноеПодразделение = ОбособленноеПодразделение; 
	ВладелецФормы.СтруктураРеквизитовФормы.ВыплатыЗПНеРегулярны 	= ВыплатыЗПНеРегулярны;
	ВладелецФормы.СтруктураРеквизитовФормы.НеВключатьЧПников 		= НеВключатьЧПников;
	ВладелецФормы.СтруктураРеквизитовФормы.МесяцПриложения 			= МесяцПриложения;
	ВладелецФормы.СтруктураРеквизитовФормы.СортироватьПоИНН 		= СортироватьПоИНН;
	ВладелецФормы.СтруктураРеквизитовФормы.ОпцияКадровыйПереводДвумяСтроками = ОпцияКадровыйПереводДвумяСтроками;
	ВладелецФормы.СтруктураРеквизитовФормы.НазначениеПенсии 	= НазначениеПенсии;
	ВладелецФормы.СтруктураРеквизитовФормы.НазначениеСоцВыплат 	= НазначениеСоцВыплат;
	ВладелецФормы.СтруктураРеквизитовФормы.ОпцияПриемУвольнениеОтдельнымиСтроками 	= ОпцияПриемУвольнениеОтдельнымиСтроками;
	Массив = Новый Массив;
	Для каждого Элемент Из Сотрудники Цикл
		Массив.Добавить(Элемент.Сотрудник);
	КонецЦикла;
	ВладелецФормы.СтруктураРеквизитовФормы.Сотрудники 	= Массив;
	
	
	//ИНАГРО++
	ВладелецФормы.СтруктураРеквизитовФормы.ЗаполнятьПоНачисленному 	= ЗаполнятьПоНачисленному;
	//ИНАГРО--	
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_ЧислоВыплатыЗП", 	  ЧислоВыплатыЗП);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_Подразделение", 	  Подразделение);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_ОбособленноеПодразделение", 	  ОбособленноеПодразделение);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_НеВключатьЧПников", 	  НеВключатьЧПников);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_НДФЛЕСВ_ОпцияКадровыйПереводДвумяСтроками", 	  ОпцияКадровыйПереводДвумяСтроками);	
	
	мПрограммноеЗакрытие = Истина;
	Отказ = Истина;
	
	ПараметрыВозврата = Новый Структура();
	
	Закрыть(ПараметрыВозврата);
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры)Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		мПрограммноеЗакрытие = Истина;
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыЗПНеРегулярныПриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная();
	СтруктураПараметров.Вставить("ЗарплатаКадрыРасширенная", ЗарплатаКадрыРасширенная);
	Если ЗарплатаКадрыРасширенная Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;

	УправлениеЭУ(СтруктураПараметров);
	
	Модифицированность = Истина;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		НеВключатьЧПников = Истина;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная();
	СтруктураПараметров.Вставить("ЗарплатаКадрыРасширенная", ЗарплатаКадрыРасширенная);
	Если ЗарплатаКадрыРасширенная Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;

	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбособленноеПодразделениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОбособленноеПодразделение) Тогда
		НеВключатьЧПников = Истина;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("ОбособленноеПодразделение", ОбособленноеПодразделение);
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная();
	СтруктураПараметров.Вставить("ЗарплатаКадрыРасширенная", ЗарплатаКадрыРасширенная);
	Если ЗарплатаКадрыРасширенная Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;
	
	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры


&НаСервере
Функция ЗаполнитьСписокПоБольничнымФССНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	БольничныйЛист.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|ГДЕ
	|	&ДатаНачала МЕЖДУ БольничныйЛист.ПериодРасчетаСреднегоЗаработкаНачало И БольничныйЛист.ПериодРасчетаСреднегоЗаработкаОкончание
	|	И БольничныйЛист.Организация = &Организация
	|	И БольничныйЛист.ПометкаУдаления = ЛОЖЬ
	|	И БольничныйЛист.Проведен = ИСТИНА
	|	И БольничныйЛист.НачисленоФСС <> 0";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДобавитьМесяц(мДатаНачалаПериодаОтчета, МесяцПриложения))); 
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат.ВыгрузитьКолонку("ФизическоеЛицо")
	
КонецФункции

&НаСервере
Функция ЗарплатаКадрыРасширенная()
	ЗарплатаКадрыРасширенная = Ложь;
	Если РегламентированнаяОтчетностьПереопределяемый.ИДПодсистемыЗарплаты() = "ЕРПЗИК" Тогда
		ЗарплатаКадрыРасширенная = Истина;
	КонецЕсли;
	Возврат ЗарплатаКадрыРасширенная
КонецФункции	


&НаКлиенте
Процедура ДодатковаПриИзмененииПенсии(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	НазначениеСоцВыплат = Ложь;
	СтруктураПараметров.Вставить("НазначениеПенсии", НазначениеПенсии);
	СтруктураПараметров.Вставить("НазначениеСоцВыплат", НазначениеСоцВыплат);
	
	СтруктураПараметров.Элементы.СписокСотрудников.Видимость  = СтруктураПараметров.НазначениеПенсии;
	
	Если СтруктураПараметров.Элементы.СписокСотрудников.Видимость = Ложь Тогда
		Сотрудники.Очистить();
	КонецЕсли;	
	
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная();
	Если ЗарплатаКадрыРасширенная Тогда
		СтруктураПараметров.Элементы.СотрудникиЗаполнитьСписокПоБольничнымФСС.Видимость = Не СтруктураПараметров.НазначениеПенсии
	Иначе
		СтруктураПараметров.Элементы.СотрудникиЗаполнитьСписокПоБольничнымФСС.Видимость = Ложь
	КонецЕсли;
	
	Модифицированность = Истина;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокПоБольничнымФСС(Команда)
	
	Если НазначениеСоцВыплат Тогда
		СписокФизическихЛиц = ЗаполнитьСписокПоБольничнымФССНаСервере()
	КонецЕсли;
	Сотрудники.Очистить();
	Если СписокФизическихЛиц.Количество() > 0 Тогда
		Для Каждого ЭлементСписка Из СписокФизическихЛиц Цикл
			НоваяСтрока = Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = ЭлементСписка
		КонецЦикла	
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеСоцВыплатПриИзменении(Элемент)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	НазначениеПенсии = Ложь;
	СтруктураПараметров.Вставить("НазначениеПенсии", НазначениеПенсии);
	СтруктураПараметров.Вставить("НазначениеСоцВыплат", НазначениеСоцВыплат);
	
	СтруктураПараметров.Элементы.СписокСотрудников.Видимость  = СтруктураПараметров.НазначениеСоцВыплат;
	Если СтруктураПараметров.Элементы.СписокСотрудников.Видимость = Ложь Тогда
		Сотрудники.Очистить();
	КонецЕсли;	
	ЗарплатаКадрыРасширенная = ЗарплатаКадрыРасширенная();
	Если ЗарплатаКадрыРасширенная Тогда
		СтруктураПараметров.Элементы.СотрудникиЗаполнитьСписокПоБольничнымФСС.Видимость = СтруктураПараметров.НазначениеСоцВыплат
	Иначе
		СтруктураПараметров.Элементы.СотрудникиЗаполнитьСписокПоБольничнымФСС.Видимость = Ложь
	КонецЕсли;
	Модифицированность = Истина;	
КонецПроцедуры







