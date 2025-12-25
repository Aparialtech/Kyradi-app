import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    const isHttpException = exception instanceof HttpException;
    const status = isHttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;
    const responseBody = isHttpException
      ? exception.getResponse()
      : { statusCode: status, message: 'Internal server error' };

    const message =
      typeof responseBody === 'string'
        ? responseBody
        : typeof responseBody === 'object' && responseBody !== null && 'message' in responseBody
        ? (responseBody as { message?: string | string[] }).message
        : 'Internal server error';

    this.logger.error(
      `${request.method} ${request.url} ${status} - ${JSON.stringify(message)}`,
      (exception as Error)?.stack,
    );

    const payload =
      typeof responseBody === 'string'
        ? { statusCode: status, message: responseBody }
        : { statusCode: status, ...(responseBody as Record<string, unknown>) };

    response.status(status).json(payload);
  }
}
