#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И НЕ ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИНАГРО_ПодключаемоеОборудование") Тогда
		ТекстСообщения = НСтр("ru='Конфигурация не поддерживает подсистему ""Подключаемое оборудование""';uk='Конфігурація не підтримує підсистему ""Обладнання для підключення""'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБСП.Форма.ИНАГРО_НастройкиПодключаемогоОборудования",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБСП.Форма.ИНАГРО_НастройкиПодключаемогоОборудования" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти