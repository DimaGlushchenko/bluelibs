
{
  id: "{{ id }}",
  label: t("{{ title }}"),
  name: {{ dataIndexStr }},
  {{# if required }}
    required: true,
  {{/ if }}
  {{# if order }}
    order: {{ order }},
  {{/ if }}
  {{# if description }}
    tooltip: t("{{ description }}"),
  {{/ if }}
  {{!-- OBJECT HANDLING --}}
  {{# if (@root.typeIs rendererType "object") }}
    {{# if isMany }}
      isList: true,
    {{/ if }}
    nest: [
      {{# each subfields }}
        {{> formXElement }}
      {{/ each }}
    ],
  {{/ if }}
  {{# unless (@root.isUndefined defaultValue) }}
    initialValue: {{ defaultValue }},
  {{/ unless }}
  {{# if form }}
    component: Ant.{{ form.component }},
    {{# if form.props }}
      componentProps: {{ form.props }},
    {{/ if }}
  {{ else }}
    {{!-- RELATION HANDLING --}}
    {{# if (@root.typeIs rendererType "relation") }}
      render: (props) => (
        <Ant.Form.Item {...props}>
          <UIComponents.RemoteSelect
              collectionClass={ {{ remoteCollectionClass }} }
              field="{{ remoteField }}"
              {{# if isMany }}
                mode="multiple"
              {{/ if }}
          />
        </Ant.Form.Item>
      ),
    {{/ if }}
    {{# if (@root.typeIs rendererType "file") }}
      component: UIComponents.AdminFileUpload,
      componentProps: { field: "{{ remoteField }}" },
    {{/ if }}
    {{# if (@root.typeIs rendererType "files") }}
      component: UIComponents.AdminFilesUpload,
      componentProps: { field: "{{ remoteField }}" },
    {{/ if }}
    {{# if (@root.typeIs rendererType "fileGroup") }}
      component: UIComponents.AdminFileGroupUpload,
      componentProps: { field: "{{ remoteField }}" },
    {{/ if }}
    {{!-- PRIMITIVE HANDLING --}}
    {{# if (@root.typeIsFormPrimitive rendererType) }}
      {{# if (@root.typeIs rendererType "string") }}
        component: Ant.Input,
      {{/ if }}
      {{# if (@root.typeIs rendererType "number") }}
        component: Ant.InputNumber,
      {{/ if }}
      {{# if (@root.typeIs rendererType "objectId") }}
        component: Ant.Input,
      {{/ if }}
      {{# if (@root.typeIs rendererType "date") }}
        component: UIComponents.DatePicker,
      {{/ if }}
      {{# if (@root.typeIs rendererType "boolean") }}
        render: (props) => (
          <Ant.Form.Item {...props}>
            <Ant.Radio.Group>
              <Ant.Radio value={false} key={0}>No</Ant.Radio>
              <Ant.Radio value={true} key={1}>Yes</Ant.Radio>
            </Ant.Radio.Group>
          </Ant.Form.Item>
        ),
      {{/ if }}
      {{# if isMany }}
        isList: true,
      {{/ if }}
    {{/ if }}
    {{!-- ENUM HANDLING --}}
    {{# if (@root.typeIs rendererType "enum") }}
      render: (props) => (
        <Ant.Form.Item {...props}>
          <Ant.Select
            {{# if isMany }}
              mode="multiple"
            {{/ if }}
            placeholder={t('{{ title }}')}
          >
            {{# each enumValues }}
              <Ant.Select.Option value="{{ value }}" key="{{ value }}">{{ label }}</Ant.Select.Option>
            {{/ each }}
          </Ant.Select>
        </Ant.Form.Item>
      ),
    {{/ if }}
  {{/ if }}
},
