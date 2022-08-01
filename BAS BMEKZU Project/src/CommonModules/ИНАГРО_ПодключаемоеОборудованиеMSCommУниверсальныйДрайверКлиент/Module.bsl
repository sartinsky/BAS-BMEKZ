
#Область ПрограммныйИнтерфейс

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*> - объект драйвера торгового оборудования.
//  Параметры - <*> - параметры драйвера торгового оборудования
//  ПараметрыПодключения - <*> - параметры подключения драйвера торгового оборудования
//  ВыходныеПараметры - <*> - выходные параметры драйвера торгового оборудования
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();

	Порт         = Неопределено;
	Скорость     = Неопределено;
	Пауза		 = 0;
	
	НачальныйНомерСимвола = 0;
	КоличествоСимволов	  = 0;		
	
	Параметры.Свойство("Порт"        , Порт);
	Параметры.Свойство("Скорость"    , Скорость);
	//Параметры.Свойство("Пауза"    	 , Пауза);
		
	Параметры.Свойство("НачальныйНомерСимвола"   , НачальныйНомерСимвола);
	Параметры.Свойство("КоличествоСимволов"    	 , КоличествоСимволов);	
		
	Если Порт         = Неопределено
	 ИЛИ Скорость     = Неопределено
	 ИЛИ КоличествоСимволов = 0 Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
        |Для корректной работы устройства необходимо задать параметры его работы.
        |Сделать это можно при помощи формы ""Настройка параметров"" модели
        |подключаемого оборудования в форме ""Подключение и настройка оборудования"".'
        |;uk='Не настроєні параметри пристрою.
        |Для коректної роботи пристрою необхідно задати параметри його роботи.
        |Зробити це можна за допомогою форми ""Настройка параметрів"" моделі
        |обладнання для підключення в формі ""Підключення та настройка обладнання"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ПараметрыПодключения.ИДУстройства = ОбъектДрайвера.CommID;
		
		Если ОбъектДрайвера.PortOpen тогда
			ОбъектДрайвера.PortOpen = "False";
		КонецЕсли;
		
		СкоростьПорта = СтрЗаменить(Строка(Параметры.Скорость)," ","");
		
		ОбъектДрайвера.CommPort   = Параметры.Порт;
		ОбъектДрайвера.Settings   = СкоростьПорта + ",n,8,1";
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*> - объект драйвера торгового оборудования.
//  Параметры - <*> - параметры драйвера торгового оборудования
//  ПараметрыПодключения - <*> - параметры подключения драйвера торгового оборудования
//  ВыходныеПараметры - <*> - выходные параметры драйвера торгового оборудования
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	Если ОбъектДрайвера.PortOpen тогда
		ОбъектДрайвера.PortOpen = "False";
	КонецЕсли;
		
	ПараметрыПодключения.ИДУстройства = Неопределено;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Получение веса
	Если Команда = "ПолучитьВес" ИЛИ Команда = "GetWeight" Тогда
		Результат = ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.';uk='Команда ""%Команда%"" не підтримується цим драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Функция осуществляет получение веса груза, расположенного на весах.
//
Функция ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	Вес = -1;
	
	Попытка
		Если НЕ ОбъектДрайвера.PortOpen Тогда
			ОбъектДрайвера.PortOpen = "True";
		КонецЕсли;	
		
		КвоСчитываемыхСимволов = 12;
		ОбъектДрайвера.Output = "R" + "<LF>" + "R" + "<LF>";
		
		ИНАГРО_МенеджерОборудованияКлиент.Пауза(Параметры.Пауза);
		
		КодОтвета = ОбъектДрайвера.Input;
		
		Если ОбъектДрайвера.PortOpen Тогда
			ОбъектДрайвера.PortOpen = "False";
		КонецЕсли;	
		
		// Если вес мы получаем сплошной строчкой (+008540012+008540012+008540012), тогда разбиваем ее на строки.
		Если Параметры.БезПереносаСтроки Тогда
			МассивСтрокОтвета = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодОтвета, Параметры.Разделитель);
			
			КолСтрок = МассивСтрокОтвета.Количество();
			
			Если КолСтрок >= 3 Тогда
				СтрокаВеса = МассивСтрокОтвета[2];
			КонецЕсли;
			
			Попытка
				Вес = Сред(СтрокаВеса, Параметры.НачальныйНомерСимвола, Параметры.КоличествоСимволов);
				Вес = Вес * Параметры.Множитель;
			Исключение
			КонецПопытки; 
			
		Иначе
			КолСтрок   = СтрЧислоСтрок(КодОтвета);	
			СтрокаВеса = СтрПолучитьСтроку(КодОтвета, КолСтрок-1);
			
			Попытка
				Вес = Сред(СтрокаВеса, Параметры.НачальныйНомерСимвола, Параметры.КоличествоСимволов);
				Вес = Вес * Параметры.Множитель;
			Исключение
			КонецПопытки
		КонецЕсли;	
		
	Исключение
		Вес = -1;
	КонецПопытки;

	Если Вес <> -1 Тогда
		ВыходныеПараметры.Добавить(Вес);
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru = 'Ошибка получения веса с весового оборудования.
									|Возможно в настройках оборудования указан не правильный Com-порт.
                                   	|'; uk = 'Помилка отримання ваги з вагопроцесора.
									|Можливо в налаштуваннях обладнання вказано невірний Com-порт.'"));
		
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

#КонецОбласти