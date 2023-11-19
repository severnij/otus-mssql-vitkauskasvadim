/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
	YEAR(i.InvoiceDate) AS year,
	MONTH(i.InvoiceDate) AS month,
	AVG(il.UnitPrice) AS average_unit_price,
	SUM(il.ExtendedPrice) AS total_invoices_amount

FROM [Sales].[InvoiceLines] AS il
	LEFT JOIN [Sales].[Invoices] AS i
		ON il.InvoiceID = i.InvoiceID

GROUP BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate)

ORDER BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate)

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
	YEAR(i.InvoiceDate) as year,
	MONTH(i.InvoiceDate) as month,
	SUM(il.ExtendedPrice) AS total_invoices_amount

FROM [Sales].[InvoiceLines] AS il
	LEFT JOIN [Sales].[Invoices] AS i
		ON il.InvoiceID = i.InvoiceID

GROUP BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate)

HAVING
	SUM(il.ExtendedPrice) > 4600000

ORDER BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate)

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
	YEAR(i.InvoiceDate) as year,
	MONTH(i.InvoiceDate) as month,
	si.StockItemName as good,
	SUM(il.ExtendedPrice) AS total_invoices_amount,
	MIN(i.InvoiceDate) AS first_invoice_date,
	SUM(il.Quantity) AS total_quantity

FROM [Sales].[InvoiceLines] AS il
	LEFT JOIN [Sales].[Invoices] AS i
		ON il.InvoiceID = i.InvoiceID
	LEFT JOIN [Warehouse].[StockItems] AS si
		ON il.StockItemID = si.StockItemID

GROUP BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate),
	si.StockItemName

HAVING
	SUM(il.Quantity) < 50

ORDER BY
	YEAR(i.InvoiceDate),
	MONTH(i.InvoiceDate),
	si.StockItemName

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
