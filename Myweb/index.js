#!/usr/bin/env nodejs
const bodyParser = require('body-parser')
const express = require('express')
const app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

let messages = []

app.get('/', (req, res) => {
    res.send("hello from index")
})

app.get('/messages', (req, res) => {
    res.json({ data: messages })
})
//สำหรับ Get 

app.post('/messages', (req, res) => {
    let inMessage = req.body.text
    let Found = false
    if (messages.length > 0) {
        messages.forEach(message => {
            if (message.text === inMessage) {
                message.count = message.count + 1
                Found = true
            }
        })
        if (!Found) {
            let data = { text: inMessage, count: 1 }
            messages.push(data)
        }
    } else {
        let data = { text: inMessage, count: 1 }
        messages.push(data)
    }

    res.status(201).json({ text: inMessage })
})
//สำหรับ Post
//Test

app.listen(3000, () => {
    console.log('Start server at port 3000.')
})