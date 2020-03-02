-- 1. Liste des contacts français :
SELECT CompanyName AS 'Société',ContactName AS 'Contact',ContactTitle AS 'Fonction',Phone AS 'Téléphone'
FROM customers
WHERE Country = 'France'

-- 2. Produits vendus par le fournisseur "Exotic Liquids" :
SELECT ProductName AS 'Produit',UnitPrice AS 'Prix'
FROM products
WHERE SupplierID = 1

-- 3. Nombre de produits vendus par les fournisseurs Français dans l'ordre décroissant :
SELECT CompanyName AS 'Fournisseur',COUNT(ProductName) AS 'Nombre de produits'
FROM products
    JOIN suppliers
    ON products.SupplierID = suppliers.SupplierID
WHERE Country = 'France'
GROUP BY CompanyName
ORDER BY COUNT(ProductName) DESC

-- 4 - Liste des clients Français ayant plus de 10 commandes :
SELECT customers.CompanyName AS 'Client',COUNT(OrderID) AS 'Nombre de commandes'
FROM customers
    JOIN orders
    ON customers.CustomerID = orders.CustomerID
WHERE Country = 'France'
GROUP BY customers.CompanyName
HAVING COUNT(OrderID) > 10

-- 5 - Liste des clients ayant un chiffre d’affaires > 30.000 :
SELECT CompanyName AS 'Client',SUM(UnitPrice * Quantity) AS 'Total prix commandé',Country AS 'Pays'
FROM `order details`
    JOIN orders 
    ON `order details`.OrderID = orders.OrderID
        JOIN customers
        ON orders.CustomerID = customers.CustomerID
GROUP BY CompanyName,Country
HAVING SUM(UnitPrice * Quantity) > 30000

-- 6 – Liste des pays dont les clients ont passé commande de produits fournis par « Exotic
-- Liquids » :
SELECT DISTINCT Country AS 'Pays'
FROM customers
    JOIN orders
    ON customers.CustomerID = orders.CustomerID
        JOIN `order details`
        ON orders.OrderID = `order details`.OrderID
            JOIN products
            ON `order details`.ProductID = products.ProductID
WHERE products.SupplierID = 1
ORDER BY Country ASC

-- 7 – Montant des ventes de 1997 :
SELECT SUM(UnitPrice * Quantity) AS 'Montant des Ventes 1997'
FROM `order details`
    JOIN orders
    ON `order details`.OrderID = orders.OrderID
WHERE OrderDate >= '1997-01-01' AND OrderDate <= '1997-12-31'

-- 8 – Montant des ventes de 1997 mois par mois :
SELECT MONTH(OrderDate) AS 'Mois 1997',SUM(UnitPrice * Quantity) AS 'Montant Ventes'
FROM `order details`
    JOIN orders
    ON `order details`.OrderID = orders.OrderID
WHERE YEAR(OrderDate) = '1997'
AND MONTH(OrderDate) BETWEEN 1 AND 12
GROUP BY MONTH(OrderDate)

-- 9 – Depuis quelle date le client « Du monde entier » n’a plus commandé ?
SELECT CustomerID,OrderDate AS 'Date de dernière commande'
FROM orders
WHERE CustomerID = 'DUMON'
ORDER BY OrderDate DESC
LIMIT 1

-- 10 – Quel est le délai moyen de livraison en jours ?
SELECT ROUND(AVG(DATEDIFF(ShippedDate,OrderDate))) AS 'Délai moyen de livraison en jours'
FROM orders