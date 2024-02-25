CREATE TABLE Human_Status (
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Group_Status (
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Action_Status (
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Corporation(
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Grouping(
  id serial primary key,
  status_id int references Group_Status on delete cascade,
  corp_id int references Corporation on delete cascade,
  name varchar(50) not null unique
);
CREATE TABLE Human_Ability(
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Hero_Ability(
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Location(
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Human(
    id serial primary key,
    name varchar(50) not null,
    post varchar(50),
    status_id int references Human_Status on delete cascade,
    ability_id int references Human_Ability on delete cascade,
    location_id int references Location on delete cascade,
    grouping_id int references Grouping
);
CREATE TABLE Animal_Type(
    id serial primary key,
    name varchar(50) not null unique
);
CREATE TABLE Animal_To_Location(
  id serial primary key,
  location_id int references Location on delete cascade,
  animal_type_id int references Animal_Type on delete cascade,
  number int not null
);
CREATE TABLE Transport(
    id int primary key,
    name varchar(50) not null unique
);
CREATE TABLE Hero(
    id serial primary key,
    name varchar(50) not null unique,
    ability_id int references Hero_Ability on delete cascade
);

CREATE TABLE Villain(
    id serial primary key,
    name varchar(50) not null unique
);
CREATE TABLE Result(
    id serial primary key,
    name varchar(50) not null unique
);

CREATE TABLE Villain_Debuffs(
  id serial primary key,
  name varchar(50) not null unique,
  description varchar(50),
  villain_id int references Villain
);

CREATE TABLE Movements(
    id serial primary key,
    location_1_id int not null references Location on delete cascade,
    location_2_id int not null references Location on delete cascade,
    transport_id int not null references Transport on delete cascade,
    hero_id int not null references Hero on delete cascade,
    time timestamp not null
);
CREATE TABLE Action_Type(
  id serial primary key,
  name varchar(50) not null unique
);
CREATE TABLE Action(
    id serial primary key,
    name varchar(50) not null,
    location_id int not null references Location on delete cascade,
    villain_debuff_id int not null references Villain_Debuffs on delete cascade,
    action_type_id int not null references Action_Type on delete restrict,
    status_id int not null references Action_Status on delete restrict
);
CREATE TABLE Action_to_Result(
    id serial primary key,
    action_id int not null references Action,
    result_id int not null references Result
);
CREATE TABLE Hero_to_Action(
    id serial primary key,
    action_id int not null references Action on delete restrict,
    hero_id int not null references Hero on delete cascade
);