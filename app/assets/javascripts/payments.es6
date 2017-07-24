const onlyUnique = (value, index, self) => {
    return self.indexOf(value) === index;
}

const firstNameSel = '.js-input-first-name'
const lastNameSel = '.js-input-last-name'
const addressSel = '.js-input-address'
const emailSel = '.js-input-email'

const validateUserInputs = () => {
  const emailRegex = /^[A-Z0-9._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
  const firstName = $(firstNameSel)
  const lastName = $(lastNameSel)
  const address= $(addressSel)
  const email = $(emailSel)
  const inputs = [firstName, lastName, address, email]

  setTimeout(() => {
    inputs.forEach((input) => {
      input.removeClass('input-error')
    })
  }, 2000)

  const textInputsValid = inputs.map((input) => {
    let length = input.val().length
    if(length < 3) {
      input.addClass('input-error')
      return false
    } else {
      return true
    }
  });

  const emailInputValid = emailRegex.test(email.val())
  if(!emailInputValid) {
    email.addClass('input-error')
  }

  const allValidations = textInputsValid.concat([emailInputValid])
  const uniqValidations = allValidations.filter(onlyUnique)
  return uniqValidations.length == 1 && uniqValidations[0] == true
}

class PaymentManager {
  constructor() {}

  setup() {
    braintree.dropin.create({
      authorization: gon.braintree_token,
      selector: '.dropin-container',
      locale: 'en_EN'
    }, (_, client) => {
      let button = $('.braintree-submit-button')
      $(button).fadeIn('fast')
      $(button).prop('disabled', false)
      $('.js-spinner').fadeOut('fast')
      $('.js-user-details').fadeIn('fast')

      button.on('click', () => {
        if(validateUserInputs() == false) {
          return
        }

        $(button).prop('disabled', true)
        client.requestPaymentMethod((err, payload) => {
          if(err) {
            $(button).prop('disabled', false)
            console.error(err)
            return
          }

          console.log(payload)
          $.post("/web/subscriptions.json", {
            nonce: payload.nonce,
            user_id: gon.user_id,
            first_name: $(firstNameSel).val(),
            last_name: $(lastNameSel).val(),
            address: $(addressSel).val(),
            email: $(emailSel).val()
          }).done((body, _, response) => {
            if(response.status == 201) {
              console.log('succsess');
              window.location = "/web/subscriptions/confirm?result=success"
            } else {
              console.log('seeerrrror');
              window.location = "/web/subscriptions/confirm?result=error"
            }
          }).fail((response) => {
            window.location = "/web/subscriptions/confirm?result=error"
          })
        })
      })
    })
  }
}

$(() => {
  const controller = $('.js-data').data('controller');
  const action = $('.js-data').data('action');

  if(controller != 'web/subscriptions' || action != 'new') {
    return
  }

  console.log('init payments');
  const manager = new PaymentManager();
  manager.setup()
})

