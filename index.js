const path = require('path');
const express = require('express');
const app = express();

const bd = {
    users:[
        {
            name: 'CharleyRog',
            money: 100
        },
        {
            name: 'Kazra',
            money: 40
        }
    ],
    mods: {

    },
    groups: {

    },
    items: [
        {
            id: 1,
            title: 'Камень',
            price: 10,
            dmg: 0,
        }
    ]
}

app.get('/', (req, res) => {
    res.send({ message: 'check connection' });
});

app.get('/save', (req, res) => {
    res.send({ message: 'save' });
});

app.get('/load', (req, res) => {
    res.send({ message: 'load' });
});

app.listen(3333, () => {
    console.log('Application listening on port 3333!');
});