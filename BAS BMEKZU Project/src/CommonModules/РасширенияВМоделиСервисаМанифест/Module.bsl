#Область СлужебныйПрограммныйИнтерфейс

// Заполняет переданный объект данными, считываемыми из манифеста расширения.
//
// Параметры:
//  Манифест - ОбъектXDTO {http://www.1c.ru/1cFresh/ConfigurationExtensions/Manifest/a.b.c.d}ConfigurationExtensionManifest -
//    манифест расширения,
//  ОбъектРасширения - объект, значения свойств которого будет установлены
//    значениями свойств расширения из манифеста (предположительно
//    СправочникОбъект.ПоставляемыеРасширения,
//  ИмяФайла - возвращаемая строка, содержит оригинальное имя файла расширения.
//
Процедура ПрочитатьМанифест(Знач Манифест, Знач ОбъектРасширения) Экспорт
	
	ОбъектРасширения.Наименование = Манифест.Name;
	ОбъектРасширения.Имя = Манифест.ObjectName;
	ОбъектРасширения.Версия = Манифест.Version;
	ОбъектРасширения.Информация = Манифест.Description;
	
	ОбъектРасширения.Разрешения.Очистить();
	
	Если Манифест.Permissions <> Неопределено Тогда
		
		Для каждого Permission Из Манифест.Permissions Цикл
			
			ТипXDTO = Permission.Тип();
			
			Разрешение = ОбъектРасширения.Разрешения.Добавить();
			Разрешение.ВидРазрешения = ТипXDTO.Имя;
			
			Параметры = Новый Структура();
			
			Для каждого СвойствоXDTO Из ТипXDTO.Свойства Цикл
				
				Контейнер = Permission.ПолучитьXDTO(СвойствоXDTO.Имя);
				
				Если Контейнер <> Неопределено Тогда
					
					Параметры.Вставить(СвойствоXDTO.Имя, Контейнер.Значение);
					
				Иначе
					
					Параметры.Вставить(СвойствоXDTO.Имя);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Разрешение.Параметры = Новый ХранилищеЗначения(Параметры);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти