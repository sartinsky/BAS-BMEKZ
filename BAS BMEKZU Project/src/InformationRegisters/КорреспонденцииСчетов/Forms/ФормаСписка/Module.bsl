
&НаКлиенте
Перем Интерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого Документ Из Метаданные.Документы Цикл
		
		Если Врег(Лев(Документ.Имя, 7)) = "УДАЛИТЬ" Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы.ОтборИмяДокумента.СписокВыбора.Добавить(Документ.Имя,Документ.Синоним);
		Элементы.ОтборИмяДокумента.СписокВыбора.СортироватьПоПредставлению();
		
	КонецЦикла;
	
	ОтборСодержаниеИстория = ХранилищеОбщихНастроек.Загрузить("РегистрСведений.КорреспонденцииСчетов", "ОтборСодержаниеИстория");
	
	Если ОтборСодержаниеИстория <> Неопределено Тогда
		Элементы.ОтборСодержание.СписокВыбора.ЗагрузитьЗначения(ОтборСодержаниеИстория);
	КонецЕсли;
	
	Если Элементы.ОтборСодержание.СписокВыбора.Количество() = 0 Тогда
		Элементы.ОтборСодержание.СписокВыбора.Добавить(НСтр("ru='товар от поставщ';uk='товар від постачальн'", Локализация.КодЯзыкаИнформационнойБазы()));
		Элементы.ОтборСодержание.СписокВыбора.Добавить(НСтр("ru='получен оплат покупателя';uk='одерж оплат покупця'", Локализация.КодЯзыкаИнформационнойБазы()));
		Элементы.ОтборСодержание.СписокВыбора.Добавить(НСтр("ru='перечислен налог';uk='перерахуван податк'", Локализация.КодЯзыкаИнформационнойБазы()));
	КонецЕсли;
	
	СохраненныеПоследниеВведенные = ХранилищеОбщихНастроек.Загрузить("РегистрСведений.КорреспонденцииСчетов", "ПоследниеВведенные");
	
	Если СохраненныеПоследниеВведенные <> Неопределено Тогда
		ПоследниеВведенные.ЗагрузитьЗначения(СохраненныеПоследниеВведенные.ВыгрузитьЗначения());
	КонецЕсли;
	
	ПоказОпераций = "Все";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Интерфейс = ОпределитьТекущийИнтерфейс();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	СохранитьПоследниеВведенные(ПоследниеВведенные);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтборСчетДтПриИзменении(Элемент)
	
	СчетДляОтбораДт = ОтборСчетДт;
	Если ЗначениеЗаполнено(СчетДляОтбораДт) Тогда
	    ПроверитьНаличиеЗаписейДтКт(СчетДляОтбораДт,ОтборСчетКт,ОтборИмяДокумента,ОтборСодержание);
	КонецЕсли; 
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список,"СчетДт", СчетДляОтбораДт,
		ЗначениеЗаполнено(СчетДляОтбораДт), ВидСравненияКомпоновкиДанных.ВИерархии);
		
	УправлениеФормой();
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетКтПриИзменении(Элемент)
	
	СчетДляОтбораКт = ОтборСчетКт;
	Если ЗначениеЗаполнено(СчетДляОтбораКт) Тогда
	    ПроверитьНаличиеЗаписейДтКт(ОтборСчетДт,СчетДляОтбораКт,ОтборИмяДокумента,ОтборСодержание);
	КонецЕсли; 
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список,"СчетКт", СчетДляОтбораКт,
		ЗначениеЗаполнено(СчетДляОтбораКт), ВидСравненияКомпоновкиДанных.ВИерархии);
		
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ОтборСодержаниеПриИзменении(Элемент)
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОтборСодержание, " ");
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		"Содержание");
	
	Для каждого Подстрока Из МассивПодстрок Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор, 
			"Содержание", 
			Подстрока, 
			ВидСравненияКомпоновкиДанных.Содержит, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный, 
			Истина); 
	КонецЦикла;
		
	Если НЕ ПустаяСтрока(ОтборСодержание) И Элементы.ОтборСодержание.СписокВыбора.НайтиПоЗначению(ОтборСодержание) = Неопределено Тогда
		Элементы.ОтборСодержание.СписокВыбора.Вставить(0, ОтборСодержание);
		СохранитьОтборСодержаниеИстория(Элементы.ОтборСодержание.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИмяДокументаПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "ИмяДокумента", ОтборИмяДокумента, 
		ЗначениеЗаполнено(ОтборИмяДокумента));
		
	УправлениеФормой();
			
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Идентификатор",
				ПоследниеВведенные,
				ПоказОпераций = "Последние",
				ВидСравненияКомпоновкиДанных.ВСписке);
				
	УправлениеФормой();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьПодвал", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущийЭлемент.Имя = "СсылкаНаИТС" Тогда
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.СсылкаНаИТС) Тогда
			ПерейтиПоНавигационнойСсылке(Элемент.ТекущиеДанные.СсылкаНаИТС);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьОперацию(Элемент.ТекущиеДанные);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВвестиОперацию(Команда)
	
	ТабличноеПоле = Элементы.Список;
	
	Если ТабличноеПоле.ТекущиеДанные <> Неопределено Тогда
		ОткрытьОперацию(ТабличноеПоле.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
//Проверяем, что есть записи для пары Дт-Кт, если нет, пытаемся подобрать счет верхнего уровня
Процедура ПроверитьНаличиеЗаписейДтКт(СчетДляОтбораДт,СчетДляОтбораКт,ОтборИмяДокумента,ОтборСодержание)
	
	СчетДт = СчетДляОтбораДт;
	СчетКт = СчетДляОтбораКт;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорреспонденцииСчетов.Идентификатор
	|ИЗ
	|	РегистрСведений.КорреспонденцииСчетов КАК КорреспонденцииСчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК ХозрасчетныйДт
	|		ПО КорреспонденцииСчетов.СчетДт = ХозрасчетныйДт.Код
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК ХозрасчетныйКт
	|		ПО КорреспонденцииСчетов.СчетКт = ХозрасчетныйКт.Код
	|ГДЕ "
	+?(ЗначениеЗаполнено(СчетДт),"ХозрасчетныйДт.Ссылка В ИЕРАРХИИ(&СчетДт)","Истина")
	+?(ЗначениеЗаполнено(СчетКт)," И ХозрасчетныйКт.Ссылка В ИЕРАРХИИ(&СчетКт)","")
	+?(ЗначениеЗаполнено(ОтборИмяДокумента)," И КорреспонденцииСчетов.ИмяДокумента = """+ОтборИмяДокумента+"""","")
	+?(ЗначениеЗаполнено(ОтборСодержание)," И КорреспонденцииСчетов.Содержание ПОДОБНО ""%"+ОтборСодержание+"%""","")
	;
	
	ИзмененыУсловия = Истина;
	Пока ИзмененыУсловия 
	   И (ЗначениеЗаполнено(СчетДт.Родитель) ИЛИ ЗначениеЗаполнено(СчетКт.Родитель)) Цикл
	   
   		Запрос.УстановитьПараметр("СчетДт",СчетДт);
		Запрос.УстановитьПараметр("СчетКт",СчетКт);
		Если Запрос.Выполнить().Пустой() Тогда
			//Записей нет, пытаемся подобрать счет верхнего уровня
			ИзмененыУсловия = Ложь;
			Если ЗначениеЗаполнено(СчетДт) И ЗначениеЗаполнено(СчетДт.Родитель) Тогда
				СчетДт = СчетДт.Родитель;
				ИзмененыУсловия = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(СчетКт) И ЗначениеЗаполнено(СчетКт.Родитель) Тогда
				СчетКт = СчетКт.Родитель;
				ИзмененыУсловия = Истина;
			КонецЕсли;
		Иначе
			//Записи есть, все в порядке, возвращаем подобранную пару
			СчетДляОтбораДт = СчетДт;
			СчетДляОтбораКт = СчетКт;
			Возврат;
		КонецЕсли;  
	   
	КонецЦикла; 		
	//Записей нет ни для отобранного, ни для счета верхнего уровня
	
КонецПроцедуры // ПроверитьНаличиеЗаписейДтКт()

&НаСервере
Функция ОпределитьТекущийИнтерфейс()

		ТекущийИнтерфейс = "Такси";
	
	Возврат ТекущийИнтерфейс;
	
КонецФункции

&НаКлиенте
Процедура УправлениеФормой()
	          
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Элементы.ВвестиОперацию.Доступность = Ложь;
	Иначе
		Элементы.ВвестиОперацию.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьПодвал()
	
	УстановитьТекстПутиКДокументу();
	УстановитьКартинкуРазделаДляПутиКДокументу();
	УстановитьСтраницуСсылкиНаИТС();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстПутиКДокументу()
	
	// установим текст для "Где найти в меню"
	ПутьКДокументу = "";
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПутьКДокументу = ПутьКДокументу + Элементы.Список.ТекущиеДанные.Раздел;
		ПутьКДокументу = ПутьКДокументу + " / " + Элементы.Список.ТекущиеДанные.Подраздел;
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ТипДокумента) Тогда
			ПутьКДокументу = ПутьКДокументу + " / " + Элементы.Список.ТекущиеДанные.ТипДокумента;	
		КонецЕсли;
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ВидОперацииДокумента) Тогда
			Если НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ЗакладкаДокумента) Тогда
				ПутьКДокументу = ПутьКДокументу + НСтр("ru=' (Вид операции: ';uk=' (Вид операції: '") + Элементы.Список.ТекущиеДанные.ВидОперацииДокумента + ")";
			Иначе
				ПутьКДокументу = ПутьКДокументу + НСтр("ru=' (Вид операции: ';uk=' (Вид операції: '") + Элементы.Список.ТекущиеДанные.ВидОперацииДокумента;
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ЗакладкаДокумента) Тогда
			Если НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ВидОперацииДокумента) Тогда
				ПутьКДокументу = ПутьКДокументу + НСтр("ru=' (Закладка: ';uk=' (Закладка: '") + Элементы.Список.ТекущиеДанные.ЗакладкаДокумента + ")";
			Иначе
				ПутьКДокументу = ПутьКДокументу + НСтр("ru=', Закладка: ';uk=', Закладка: '") + Элементы.Список.ТекущиеДанные.ЗакладкаДокумента + ")";
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	Если ПутьКДокументу = "" Тогда
		Элементы.ДекорацияПутьКДокументуЗаголовок.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияПутьКДокументуЗаголовок.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКартинкуРазделаДляПутиКДокументу()
	
	// выберем картинку раздела для "Где найти в меню"	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ТекущаяКартинка = Новый Картинка;
	Иначе
		ПутьКДокументуРаздел = Элементы.Список.ТекущиеДанные.Раздел;
		
		Если ПутьКДокументуРаздел = "Главное" ИЛИ ПутьКДокументуРаздел = "Головне" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Главное;
		ИначеЕсли ПутьКДокументуРаздел = "Банк и касса" ИЛИ ПутьКДокументуРаздел = "Банк і каса" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.БанкИКасса;
		ИначеЕсли ПутьКДокументуРаздел = "Покупки" ИЛИ ПутьКДокументуРаздел = "Купівлі" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Покупки;
		ИначеЕсли ПутьКДокументуРаздел = "Продажи" ИЛИ ПутьКДокументуРаздел = "Продажі" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Продажи;
		ИначеЕсли ПутьКДокументуРаздел = "Склад" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Склад;
		ИначеЕсли ПутьКДокументуРаздел = "Производство" ИЛИ ПутьКДокументуРаздел = "Виробництво" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Производство;
		ИначеЕсли ПутьКДокументуРаздел = "ОС и НМА" ИЛИ ПутьКДокументуРаздел = "ОЗ і НМА" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.ОС;
		ИначеЕсли ПутьКДокументуРаздел = "Зарплата и кадры" ИЛИ ПутьКДокументуРаздел = "Зарплата і кадри" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Сотрудники;
		ИначеЕсли ПутьКДокументуРаздел = "Отчеты" ИЛИ ПутьКДокументуРаздел = "Звіти" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Отчеты;
		ИначеЕсли ПутьКДокументуРаздел = "Справочники" ИЛИ ПутьКДокументуРаздел = "Довідники" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Справочники;
		ИначеЕсли ПутьКДокументуРаздел = "Операции" ИЛИ ПутьКДокументуРаздел = "Операції" Тогда
			ТекущаяКартинка = БиблиотекаКартинок.Операции;
		Иначе
			ТекущаяКартинка = БиблиотекаКартинок.Операции;
		КонецЕсли;
	КонецЕсли;
	Элементы.ДекорацияКартинкаРаздела.Картинка = ТекущаяКартинка;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтраницуСсылкиНаИТС()
	
	// установим видимость гиперссылки на пример на ИТС
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		Если Интерфейс = "Такси" Тогда
			Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.СсылкаНаИТС) Тогда
				Элементы.ГруппаСсылкаНаИТС.ТекущаяСтраница = Элементы.ГруппаЕстьСсылкаНаИТС;		
			Иначе
				Элементы.ГруппаСсылкаНаИТС.ТекущаяСтраница = Элементы.ГруппаНетСсылкиНаИТС;		
			КонецЕсли;	
		Иначе
			Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.СсылкаНаИТС82) Тогда
				Элементы.ГруппаСсылкаНаИТС.ТекущаяСтраница = Элементы.ГруппаЕстьСсылкаНаИТС;		
			Иначе
				Элементы.ГруппаСсылкаНаИТС.ТекущаяСтраница = Элементы.ГруппаНетСсылкиНаИТС;		
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ГруппаСсылкаНаИТС.ТекущаяСтраница = Элементы.ГруппаНетСсылкиНаИТС;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОперацию(ДанныеСтроки)
	
	ДобавитьОперациюВСписокПоследнихВведенных(ДанныеСтроки.Идентификатор);
	
	ИмяДокумента = ДанныеСтроки.ИмяДокумента;
	
	Если Не ЗначениеЗаполнено(ИмяДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ВидОперацииДокумента) Тогда
		ВидОперации = ДанныеСтроки.ВидОперацииДокумента;
		ИмяПараметра = ?(ИмяДокумента = "ВводНачальныхОстатков", "РазделУчета", "ВидОперации");
		ЗначенияЗаполнения.Вставить(ИмяПараметра, ВидОперации);
	КонецЕсли;
	
	Если ИмяДокумента = "ОперацияБух" Тогда
		
		ЗначенияЗаполнения.Вставить("Содержание",   ДанныеСтроки.Содержание);
		ЗначенияЗаполнения.Вставить("Хозрасчетный", Новый Массив);
		
		НоваяПроводка = Новый Структура;
		НоваяПроводка.Вставить("СчетДт", ДанныеСтроки.СчетДт);
		НоваяПроводка.Вставить("СчетКт", ДанныеСтроки.СчетКт);
		НоваяПроводка.Вставить("Содержание", ДанныеСтроки.Содержание);
		ЗначенияЗаполнения.Хозрасчетный.Добавить(НоваяПроводка);
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ." + ИмяДокумента + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОперациюВСписокПоследнихВведенных(Идентификатор)
	
	НайденноеЗначение = ПоследниеВведенные.НайтиПоЗначению(Идентификатор);
	
	Если НайденноеЗначение = Неопределено Тогда
		Если ПоследниеВведенные.Количество() > 10 Тогда
			ПоследниеВведенные.Удалить(0);
		КонецЕсли;
	Иначе
		ПоследниеВведенные.Удалить(НайденноеЗначение);
	КонецЕсли;
	ПоследниеВведенные.Добавить(Идентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьОтборСодержаниеИстория(МассивСтрок)
	
	ХранилищеОбщихНастроек.Сохранить("РегистрСведений.КорреспонденцииСчетов", "ОтборСодержаниеИстория", МассивСтрок);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьПоследниеВведенные(ПоследниеВведенные)
	
	ХранилищеОбщихНастроек.Сохранить("РегистрСведений.КорреспонденцииСчетов", "ПоследниеВведенные", ПоследниеВведенные);	
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСсылкаНаИТСНажатие(Элемент)
	
	Если Интерфейс = "Такси" Тогда
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.СсылкаНаИТС) Тогда
			ПерейтиПоНавигационнойСсылке(Элементы.Список.ТекущиеДанные.СсылкаНаИТС);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.СсылкаНаИТС82) Тогда
		ПерейтиПоНавигационнойСсылке(Элементы.Список.ТекущиеДанные.СсылкаНаИТС82);	
	КонецЕсли;
	
КонецПроцедуры
