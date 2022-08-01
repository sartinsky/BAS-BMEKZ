#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Табель учета рабочего времени
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "П5";
	КомандаПечати.Представление = НСтр("ru='Форма П-5';uk='Форма П-5'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Табель учета рабочего времени организации""';uk='Реєстр документів ""Табель обліку робочого часу організації""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "П5") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "П5", НСтр("ru='Форма П-5';uk='Форма П-5'"), 
		ПечатьТабеля(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,"Отчет.ИНАГРО_ТиповаяФормаП5.П5", ,Истина);
	КонецЕсли;  		                                                                                                                     
	
КонецПроцедуры

Функция ПечатьТабеля(МассивОбъектов, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Получить экземпляр документа на печать
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		Запрос = Новый Запрос;
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ОтработанноеВремя.Назначение КАК Сотрудник
			|ИЗ
			|	Документ.ИНАГРО_ТабельУчетаРабочегоВремениОрганизации.ОтработанноеВремя КАК ОтработанноеВремя
			|ГДЕ
			|	ОтработанноеВремя.Ссылка = &ДокументСсылка
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ОтработанноеВремяВЦеломЗаПериод.Назначение
			|ИЗ
			|	Документ.ИНАГРО_ТабельУчетаРабочегоВремениОрганизации.ОтработанноеВремяВЦеломЗаПериод КАК ОтработанноеВремяВЦеломЗаПериод
			|ГДЕ
			|	ОтработанноеВремяВЦеломЗаПериод.Ссылка = &ДокументСсылка";
		
		Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

		СписокСотрудников = Новый СписокЗначений;
		СписокСотрудников.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник"));
			
		ФильтрСоответствия = Новый Соответствие;
		ФильтрСоответствия.Вставить("Организация", Ссылка.Организация);
		ФильтрСоответствия.Вставить("Подразделение", Ссылка.ПодразделениеОрганизации);
		ФильтрСоответствия.Вставить("НачалоПериода",Ссылка.ДатаНачалаПериода);
		ФильтрСоответствия.Вставить("КонецПериода",Ссылка.ДатаОкончанияПериода);
		ФильтрСоответствия.Вставить("ОтборПоОрганизации", ЗначениеЗаполнено(Ссылка.Организация));
		ФильтрСоответствия.Вставить("ОтборПоПодразделению", ЗначениеЗаполнено(Ссылка.ПодразделениеОрганизации));
		ФильтрСоответствия.Вставить("ПериодРегистрации", Ссылка.ПериодРегистрации);
		ФильтрСоответствия.Вставить("ДатаЗаполнения", Ссылка.Дата);
		ФильтрСоответствия.Вставить("Ответственный", Ссылка.Ответственный);
		
		Если СписокСотрудников.Количество() = 1 Тогда
			ФильтрСоответствия.Вставить("Работник", СписокСотрудников[0].Значение);
			ФильтрСоответствия.Вставить("ОтборПоРаботнику", Истина);
		ИначеЕсли СписокСотрудников.Количество() > 1 Тогда
			ФильтрСоответствия.Вставить("Работник", СписокСотрудников);
			ФильтрСоответствия.Вставить("ОтборПоРаботнику", Истина);
		КонецЕсли;
		
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.АвтоМасштаб = Истина;
		ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ИНАГРО_ТиповаяФормаП5.П5");
		
		// печать производится на языке, указанном в настройках пользователя
		КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
		Макет.КодЯзыкаМакета = КодЯзыкаПечать; 
		
		Отчет = Отчеты.ИНАГРО_ТиповаяФормаП5.Создать();
		Отчет.УстановитьФильтр(ФильтрСоответствия);
		ТекстОшибки = "";
		Отчет.СформироватьТабель(ТабДокумент,ТекстОшибки);
		Если ТекстОшибки <> "" Тогда
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат  ТабДокумент;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ДоступныеДляВводаВидыВремени() Экспорт
	
	ДоступныеДляВводаВидыВремени = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыИспользованияРабочегоВремени.Ссылка КАК ОсновноеВремя
	|ИЗ
	|	Справочник.ИНАГРО_КлассификаторИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДоступныеДляВводаВидыВремени.Вставить(Выборка.ОсновноеВремя, Истина);
	КонецЦикла;
	
	Возврат ДоступныеДляВводаВидыВремени;
	
КонецФункции	

#КонецОбласти

#КонецЕсли







