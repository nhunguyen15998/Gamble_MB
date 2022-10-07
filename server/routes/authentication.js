const datas = require('../datas');

var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});


router.post('/sign-in', function(req, res, next){
    const {phone, password} = req.body
    if(phone && password){
        if(phone != '0849345639'){
            return res.json({
                'status': 500,
                'message': 'Whoops! Wrong phone number'
            })
        }

        if(password != '123456'){
            return res.json({
                'status': 500,
                'message': 'Whoops! Wrong password'
            })
        }

        const user = datas.user

        return res.json({
            'status': 200,
            'message': 'Sign in successfully',
            data: user
        })

    }

    return res.json({
        'status': 500,
        'message': 'Whoops! Invalid credentials'
    })
})

module.exports = router;
