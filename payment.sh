component=payment
source common.sh
if [ -z "${rabbitmq_root_password}" ]; then
  echo Input RabbitMQ AppUser Password Missing
  exit 1
fi
func_python
