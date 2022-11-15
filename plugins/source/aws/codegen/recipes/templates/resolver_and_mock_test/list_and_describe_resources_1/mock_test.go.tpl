// Code generated by codegen; DO NOT EDIT.

package {{.Service}}

import (
	"testing"

	"github.com/aws/aws-sdk-go-v2/service/{{.Service}}"
	"github.com/aws/aws-sdk-go-v2/service/{{.Service}}/types"
	{{- if not .Parent }}
	"github.com/cloudquery/cloudquery/plugins/source/aws/client"
	{{- end }}
	"github.com/cloudquery/cloudquery/plugins/source/aws/client/mocks"
	"github.com/cloudquery/plugin-sdk/faker"
	"github.com/golang/mock/gomock"
)

{{- if .Parent }}
func build{{.Service | ToCamel}}{{.SubService | ToCamel}}Mock(t *testing.T, m *mocks.MockKafkaClient) {
{{- else }}
func build{{.Service | ToCamel}}{{.SubService | ToCamel}}Mock(t *testing.T, ctrl *gomock.Controller) client.Services {
  m := mocks.NewMock{{.CloudQueryServiceName}}Client(ctrl)
{{- end }}
  object := types.{{.StructName}}{}
  err := faker.FakeObject(&object)
  if err != nil {
		t.Fatal(err)
	}

{{- range $i, $ch := .Children }}
    build{{$ch.Service | ToCamel}}{{$ch.SubService | ToCamel}}Mock(t, m)
{{- end }}

  m.EXPECT().{{.ListMethod.Method.Name}}(gomock.Any(), gomock.Any(), gomock.Any()).Return(
    &{{.Service}}.{{.ListMethod.Method.Name}}Output{
      {{.ListMethod.OutputFieldName}}: []types.{{.StructName}}{object},
    }, nil)

  m.EXPECT().{{.DescribeMethod.Method.Name}}(gomock.Any(), gomock.Any(), gomock.Any()).Return(
    &{{.Service}}.{{.DescribeMethod.Method.Name}}Output{
      {{.DescribeMethod.OutputFieldName}}: &object,
    }, nil)

{{ $listTagsMethod := .ListTagsMethod}}
{{- if $listTagsMethod.Found }}
	tagsOutput := {{.Service}}.{{$listTagsMethod.Method.Name}}Output{}
	err = faker.FakeObject(&tagsOutput)
	if err != nil {
		t.Fatal(err)
	}
	m.EXPECT().{{$listTagsMethod.Method.Name}}(gomock.Any(), gomock.Any()).Return(&tagsOutput, nil).AnyTimes()
{{- end }}

  return client.Services{
    {{.CloudQueryServiceName}}: m,
  }
}

{{- if not .Parent }}
func Test{{.Service | ToCamel}}{{.SubService | ToCamel}}(t *testing.T) {
  client.AwsMockTestHelper(t, {{.SubService | ToCamel}}(), build{{.Service | ToCamel}}{{.SubService | ToCamel}}Mock, client.TestOptions{})
}
{{- end }}