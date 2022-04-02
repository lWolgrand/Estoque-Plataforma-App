CREATE TABLE IF NOT EXISTS Invoices (
    id SERIAL PRIMARY KEY,
    path TEXT NOT NULL,    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS DeviceStatus (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Sources (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Locations (
    id SERIAL PRIMARY KEY,
    contact_name TEXT NOT NULL,
    contact_info TEXT NOT NULL,
    contact_address TEXT NOT NULL,    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Devices (
    id SERIAL PRIMARY KEY,
    serial_number TEXT DEFAULT NULL,
    device_name TEXT NOT NULL,
    device_description TEXT DEFAULT NULL,
    id_source INT REFERENCES Sources(id),
    id_category INT REFERENCES Categories(id),
    id_status INT REFERENCES DeviceStatus(id),  
    id_location INT REFERENCES Locations(id),  
    id_invoice_in INT REFERENCES Invoices(id),
    id_invoice_out INT REFERENCES Invoices(id),    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Locations_audit (
    id SERIAL PRIMARY KEY,
    id_device INT REFERENCES Devices(id),
    id_location INT REFERENCES Devices(id),        
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    enable BOOLEAN DEFAULT TRUE
);

CREATE IF NOT EXISTS VIEW VW_DEVICES AS
    SELECT 
        Devices.id id_device,
        Devices.serial_number,
        Devices.device_name,
        Devices.device_description,
        Sources.name source_name,
        Categories.name category_name,
        DeviceStatus.name device_status_name,
        Locations.contact_name location_contact_name,
        Locations.contact_info location_contact_info,
        Locations.contact_address location_contact_address,
        InvoicesIn.path invoice_in_path,
        InvoicesOut.path invoice_out_path,
        Devices.created_at,
        Devices.updated_at
    FROM
        Devices 
        INNER JOIN Sources ON Devices.id_source = Sources.id
        INNER JOIN Categories ON Devices.id_category = Categories.id
        INNER JOIN DeviceStatus ON Devices.id_status = DeviceStatus.id
        INNER JOIN Locations ON Devices.id_location = Locations.id
        INNER JOIN Invoices InvoicesIn ON Devices.id_invoice_in = InvoicesIn.id
        INNER JOIN Invoices InvoicesOut ON Devices.id_invoice_out = InvoicesOut.id
    WHERE
        Devices.enable = TRUE